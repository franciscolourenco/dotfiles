import type { FinickyConfig } from "/Applications/Finicky.app/Contents/Resources/finicky.d.ts";
import { slackRewriter } from "./slack.ts";

// Apps considered "personal" — links opened from these go to Dia.
const PERSONAL_APPS = [
  "/Applications/WhatsApp.app",
  "/System/Applications/Mail.app",
  "/Applications/Telegram.app",
  "/Applications/Signal.app",
  "/System/Applications/Messages.app",
];

// Apps considered "work" — links opened from these go to Arc.
const WORK_APPS = ["/Applications/Slack.app", "/Applications/Cursor.app"];

export default {
  // Unmatched URLs fall through to Choosy, which shows its picker
  defaultBrowser: "Choosy",
  rewrite: [slackRewriter],
  handlers: [
    {
      match: (url) => url.protocol === "slack:",
      browser: "Slack",
    },
    {
      // Framer Notion workspace → Notion desktop app
      match: (url) =>
        (url.host === "www.notion.so" || url.host === "notion.so") &&
        url.pathname.startsWith("/framer"),
      browser: "Notion",
    },
    {
      // Links opened from personal apps → Dia
      match: (_url, { opener }) =>
        opener !== null && PERSONAL_APPS.includes(opener.path),
      browser: "Dia",
    },
    {
      // Links opened from work apps → Arc
      match: (_url, { opener }) =>
        opener !== null && WORK_APPS.includes(opener.path),
      browser: "Arc",
    },
  ],
} satisfies FinickyConfig;
