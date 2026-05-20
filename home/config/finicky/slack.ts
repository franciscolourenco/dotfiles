import type {
  BrowserHandler,
  UrlRewriteRule,
} from "/Applications/Finicky.app/Contents/Resources/finicky.d.ts";

// Workspace subdomain → Slack team id. Needed because <workspace>.slack.com
// URLs don't expose the team id in the URL itself. Find a team id by
// opening any channel in the Slack web app — the URL will be
// https://app.slack.com/client/<team>/<channel>.
const TEAM_IDS: Record<string, string> = {
  "framer-team.slack.com": "T3LJ82GGK",
};

type Kind = "channel" | "file" | "team";
type Parsed = { kind: Kind; id: string; message?: string };
type AppParsed = Parsed & { team: string };

// NB: numbered (not named) capture groups — Finicky's JS runtime is Goja
// (https://github.com/dop251/goja), which parses (?<name>...) syntax but
// never populates `match.groups`. See goja#659.

// app.slack.com URLs carry the team id in the path itself.
const APP_PATTERNS: Array<{
  re: RegExp;
  parse: (m: RegExpMatchArray) => AppParsed;
}> = [
  {
    re: /^\/client\/(\w+)\/\w+\/files\/(\w+)/,
    parse: (m) => ({ kind: "file", team: m[1], id: m[2] }),
  },
  {
    re: /^\/client\/(\w+)\/\w+\/user_profile\/(\w+)/,
    parse: (m) => ({ kind: "team", team: m[1], id: m[2] }),
  },
  // Thread permalink: /client/<team>/<channel>/thread/<channel>-<ts>.
  // Must come before the generic channel pattern below.
  {
    re: /^\/client\/(\w+)\/(\w+)\/thread\/\w+-([\d.]+)/,
    parse: (m) => ({ kind: "channel", team: m[1], id: m[2], message: m[3] }),
  },
  {
    re: /^\/client\/(\w+)\/(\w+)(?:\/([\d.]+))?/,
    parse: (m) => ({ kind: "channel", team: m[1], id: m[2], message: m[3] }),
  },
  // Bare file URL (e.g. from email notifications): /files/<team>/<file>.
  {
    re: /^\/files\/(\w+)\/(\w+)/,
    parse: (m) => ({ kind: "file", team: m[1], id: m[2] }),
  },
  // Canvas / doc: /docs/<team>/<id> — deep-linked via slack://file.
  {
    re: /^\/docs\/(\w+)\/(\w+)/,
    parse: (m) => ({ kind: "file", team: m[1], id: m[2] }),
  },
];

// Workspace-subdomain URLs need an explicit team id mapping.
const WORKSPACE_PATTERNS: Array<{
  re: RegExp;
  parse: (m: RegExpMatchArray) => Parsed;
}> = [
  {
    re: /^\/(?:messages|archives)\/\w+\/files\/(\w+)/,
    parse: (m) => ({ kind: "file", id: m[1] }),
  },
  {
    re: /^(?:\/messages\/\w+)?\/team\/(\w+)/,
    parse: (m) => ({ kind: "team", id: m[1] }),
  },
  {
    re: /^\/(?:messages|archives)\/(\w+)(?:\/p(\d+))?/,
    parse: (m) => ({
      kind: "channel",
      id: m[1],
      // Convert permalink p-timestamps (e.g. p1747234567890123) to
      // dotted form (1747234567.890123) that slack:// expects.
      message: m[2] ? `${m[2].slice(0, -6)}.${m[2].slice(-6)}` : undefined,
    }),
  },
];

const isSlackUrl = (url: URL): boolean =>
  url.host.endsWith(".slack.com") || url.host === "slack.com";

// Paths Slack desktop can't render — keep them in the browser, no warning.
// Covers marketing/help pages, API docs, and app.slack.com flows that need
// a real browser (workspace-add/SSO callbacks, admin console, account
// settings, sign-in/out).
const isNonDeepLinkable = (url: URL): boolean => {
  if (url.host === "slack.com") return true;
  if (url.host === "api.slack.com") return true;
  if (url.host === "app.slack.com") {
    const p = url.pathname;
    return (
      p.startsWith("/ssb/") ||
      p.startsWith("/admin/") ||
      p.startsWith("/account/") ||
      p.startsWith("/manage/") ||
      p.startsWith("/signin") ||
      p.startsWith("/signout") ||
      p.startsWith("/get-started")
    );
  }
  return false;
};

const buildDeepLink = (
  kind: Kind,
  team: string,
  id: string,
  message?: string,
  threadTs?: string | null,
): URL => {
  const params = new URLSearchParams({ team, id });
  if (message) params.set("message", message);
  if (threadTs) params.set("thread_ts", threadTs);
  return new URL(`slack://${kind}?${params.toString()}`);
};

/**
 * Rewrite Slack web URLs to `slack://` deep links so they open directly in
 * the Slack desktop app.
 *
 * Adapted from @opalelement's v3 config in
 * https://github.com/johnste/finicky/issues/96#issuecomment-844571182
 * but ported to Finicky v4 and trimmed to the URL shapes we actually
 * encounter.
 *
 * Supported shapes:
 *   <workspace>.slack.com/archives/<channel>
 *   <workspace>.slack.com/archives/<channel>/p<ts>[?thread_ts=…]
 *   <workspace>.slack.com/messages/<channel>/files/<file>
 *   <workspace>.slack.com[/messages/<channel>]/team/<user>
 *   app.slack.com/client/<team>/<channel>[/<message_ts>]
 *   app.slack.com/client/<team>/<channel>/thread/<channel>-<ts>
 *   app.slack.com/client/<team>/<channel>/files/<file>
 *   app.slack.com/client/<team>/<channel>/user_profile/<user>
 *   app.slack.com/files/<team>/<file>
 *   app.slack.com/docs/<team>/<canvas>
 *
 * URLs that intentionally bypass the rewriter (kept in the browser):
 *   slack.com/* (marketing, help)
 *   api.slack.com/* (API docs)
 *   app.slack.com/{ssb,admin,account,manage,signin,signout,get-started}/*
 */
export const slackRewriter: UrlRewriteRule = {
  match: isSlackUrl,
  url: (url) => {
    if (isNonDeepLinkable(url)) return url;

    const threadTs = url.searchParams.get("thread_ts");

    if (url.host === "app.slack.com") {
      for (const { re, parse } of APP_PATTERNS) {
        const m = url.pathname.match(re);
        if (m) {
          const p = parse(m);
          return buildDeepLink(p.kind, p.team, p.id, p.message, threadTs);
        }
      }
    } else {
      const team = TEAM_IDS[url.host];
      if (!team) {
        console.warn(
          `finicky: no team id mapped for ${url.host}; ` +
            "add it to TEAM_IDS in slack.ts to enable Slack deep linking.",
        );
        return url;
      }
      for (const { re, parse } of WORKSPACE_PATTERNS) {
        const m = url.pathname.match(re);
        if (m) {
          const p = parse(m);
          return buildDeepLink(p.kind, team, p.id, p.message, threadTs);
        }
      }
    }

    console.warn(`finicky: could not deep-link Slack URL ${url.href}`);
    return url;
  },
};
