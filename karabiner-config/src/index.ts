import { execFileSync } from 'child_process'
import {
  ifApp,
  ifVar,
  map,
  rule,
  writeToProfile,
} from 'karabiner.ts'


// Update karabiner.json
writeToProfile('Default', [
  rule('Toggle Spotify play/pause').manipulators([
    map('f8').to$('osascript -e \'tell application "Spotify" to playpause\''),
  ]),

  rule('cmd+t to cmd+p in Notion').manipulators([
    map('t', 'left_command')
      .to('p', 'left_command')
      .condition(ifApp('^notion\\.id$')),
  ]),

  rule('Caps Lock → Hyper / Launchbar').manipulators([
    map('caps_lock')
      .toHyper()
      .toIfAlone('l', ['left_command', 'left_option']),

    map('a', 'Hyper').toApp('Arc'),
    map('c', 'Hyper').toApp('Cursor'),
    map('d', 'Hyper').toApp('Dia'),
    map('f', 'Hyper').toApp('Finder'),
    map('g', 'Hyper').toApp('Google Chrome'),
    map('l', 'Hyper').toApp('Slack'),
    map('m', 'Hyper').toApp('Mail'),
    map('n', 'Hyper').toApp('Notion'),
    map('s', 'Hyper').toApp('Sublime Text'),
    map('t', 'Hyper').toApp('iTerm'),
    map('v', 'Hyper').toApp('Visual Studio Code'),
    map('w', 'Hyper').toApp('WhatsApp'),

    map('caps_lock', 'right_shift')
      .to('k', 'left_command')
      .condition(ifApp('^com\\.linear$')),

    map('caps_lock', 'right_shift')
      .to('l', 'left_command')
      .condition(ifApp('^company\\.thebrowser\\.Browser$')),

    map('caps_lock', 'right_shift')
      .to('l', ['left_command', 'left_option', 'right_shift'])
      .condition(ifApp([
        '^com\\.exafunction\\.windsurf$',
        '^com\\.microsoft\\.VSCode$',
        '^com\\.todesktop\\.230313mzl4w4u92$',
      ]).unless()),

    map('caps_lock', 'right_shift')
      .to('p', ['left_command', 'right_shift'])
      .condition(ifApp([
        '^com\\.exafunction\\.windsurf$',
        '^com\\.microsoft\\.VSCode$',
        '^com\\.todesktop\\.230313mzl4w4u92$',
      ])),

    map('caps_lock', 'right_shift')
      .to('p', 'left_command')
      .condition(ifApp('^dev\\.warp\\.Warp-Stable$')),
  ]),

  rule('Thumbsense').manipulators([
    map('f', { optional: 'any' })
      .toPointingButton('button1')
      .condition(ifVar('multitouch_extension_finger_count_total', 1)),
    map('d', { optional: 'any' })
      .toPointingButton('button2')
      .condition(ifVar('multitouch_extension_finger_count_total', 1)),
    map('g')
      .toPointingButton('button1', 'left_command')
      .condition(ifVar('multitouch_extension_finger_count_total', 1)),
    map('w')
      .to('w', 'left_command')
      .condition(ifVar('multitouch_extension_finger_count_total', 1)),
    map('v')
      .to('v', 'left_command')
      .condition(ifVar('multitouch_extension_finger_count_total', 1)),
    map('c')
      .to('c', 'left_command')
      .condition(ifVar('multitouch_extension_finger_count_total', 1)),
    map('x')
      .to('x', 'left_command')
      .condition(ifVar('multitouch_extension_finger_count_total', 1)),
  ]),
], {
  'basic.to_delayed_action_delay_milliseconds': 110,
  'basic.to_if_alone_timeout_milliseconds': 109,
  'basic.to_if_held_down_threshold_milliseconds': 110,
})



// Automatically reload karabiner config after writing to the profile
const cli =
  '/Library/Application Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli'
const profile = execFileSync(cli, ['--show-current-profile-name'], {
  encoding: 'utf-8',
}).trim()
execFileSync(cli, ['--select-profile', profile])

// ============================================================
// OLD / UNUSED CODE from karabiner.edn (kept for reference)
// ============================================================

// rule('mod-tap layers').manipulators([
//   map('spacebar')
//     .toIfAlone('spacebar')
//     .toIfHeldDown(toSetVar('homerow-mode', 1))
//     .toAfterKeyUp(toSetVar('homerow-mode', 0))
//     .condition(ifVar('tab-mode', 0)),
//
//   map('tab')
//     .toIfAlone('tab')
//     .toIfHeldDown(toSetVar('tab-mode', 1))
//     .toAfterKeyUp(toSetVar('tab-mode', 0))
//     .condition(ifVar('homerow-mode', 0)),
// ]),

// rule('Homerow Mode').manipulators([
//   // modifiers + cut/copy/paste
//   map('f', { optional: 'any' }).to('left_command').toIfAlone('v', 'left_command').condition(ifVar('homerow-mode', 1)),
//   map('d', { optional: 'any' }).to('left_option').toIfAlone('c', 'left_command').condition(ifVar('homerow-mode', 1)),
//   map('s', { optional: 'any' }).to('left_control').toIfAlone('x', 'left_command').condition(ifVar('homerow-mode', 1)),
//   map('a', { optional: 'any' }).to('left_shift').toIfAlone('s', 'left_control').condition(ifVar('homerow-mode', 1)),
//   map('g', { optional: 'any' }).to('left_shift').to('left_control').to('left_option').to('left_command').toIfAlone('d', ['left_control', 'left_shift']).condition(ifVar('homerow-mode', 1)),
//
//   // directional
//   map('i', { optional: 'any' }).to('up_arrow').condition(ifVar('homerow-mode', 1)),
//   map('k', { optional: 'any' }).to('down_arrow').condition(ifVar('homerow-mode', 1)),
//   map('j', { optional: 'any' }).to('left_arrow').condition(ifVar('homerow-mode', 1)),
//   map('l', { optional: 'any' }).to('right_arrow').condition(ifVar('homerow-mode', 1)),
//
//   // editing
//   map('u', { optional: 'any' }).to('delete_or_backspace').condition(ifVar('homerow-mode', 1)),
//   map('o', { optional: 'any' }).to('spacebar').condition(ifVar('homerow-mode', 1)),
//   map('p', { optional: 'any' }).to('delete_forward').condition(ifVar('homerow-mode', 1)),
//
//   // return / escape
//   map('semicolon', { optional: 'any' }).to('return_or_enter').condition(ifVar('homerow-mode', 1)),
//   map('quote', { optional: 'any' }).to('escape').condition(ifVar('homerow-mode', 1)),
//
//   // undo / redo
//   map('h', { optional: 'any' }).to('z', 'left_command').condition(ifVar('homerow-mode', 1)),
//   map('n', { optional: 'any' }).to('z', ['left_command', 'left_shift']).condition(ifVar('homerow-mode', 1)),
//
//   // other commands
//   map('slash', { optional: 'any' }).to('slash', 'left_command').condition(ifVar('homerow-mode', 1)),
//   map('backslash', { optional: 'any' }).to('backslash', 'left_command').condition(ifVar('homerow-mode', 1)),
//   map('t', { optional: 'any' }).to('t', 'left_command').condition(ifVar('homerow-mode', 1)),
//   map('e', { optional: 'any' }).to('f', 'left_command').condition(ifVar('homerow-mode', 1)),
//   map('w', { optional: 'any' }).to('w', 'left_command').condition(ifVar('homerow-mode', 1)),
// ]),

// rule('Tab Mode').manipulators([
//   // change app
//   map('l').to('tab', 'left_command').condition(ifVar('tab-mode', 1)),
//   map('j').to('tab', ['left_command', 'left_shift']).condition(ifVar('tab-mode', 1)),
//   map('quote').to('q', 'left_command').condition(ifVar('tab-mode', 1)),
//
//   // change windows
//   map('i').to('grave_accent_and_tilde', 'left_command').condition(ifVar('tab-mode', 1)),
//   map('k').to('grave_accent_and_tilde', ['left_command', 'left_shift']).condition(ifVar('tab-mode', 1)),
//
//   // change tabs
//   map('u').to('left_arrow', ['left_command', 'left_option']).condition(ifVar('tab-mode', 1)),
//   map('o').to('right_arrow', ['left_command', 'left_option']).condition(ifVar('tab-mode', 1)),
//   map('semicolon').to('slash').condition(ifVar('tab-mode', 1), ifApp('^com\\.linear$')),
//   map('semicolon').to('p', 'left_command').condition(ifVar('tab-mode', 1), ifApp('^notion\\.id$')),
//   map('semicolon').to('t', 'left_command').condition(ifVar('tab-mode', 1)),
//   map('y').to('w', 'left_command').condition(ifVar('tab-mode', 1)),
//   map('w').to('w', 'left_command').condition(ifVar('tab-mode', 1)),
//   map('h').to('t', ['left_command', 'left_shift']).condition(ifVar('tab-mode', 1)),
// ]),

// rule('Window Management Mode').manipulators([
//   map('l').to('right_arrow', ['left_control', 'left_option']).condition(ifVar('windowmode', 1)),
//   map('j').to('left_arrow', ['left_control', 'left_option']).condition(ifVar('windowmode', 1)),
//   map('i').to('up_arrow', ['left_control', 'left_option']).condition(ifVar('windowmode', 1)),
//   map('k').to('down_arrow', ['left_control', 'left_option']).condition(ifVar('windowmode', 1)),
//   map('semicolon').to('return_or_enter', ['left_control', 'left_option']).condition(ifVar('windowmode', 1)),
// ]),
