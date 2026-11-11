{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;

  bind = key: action: {
    _args = [
      key
      (lua action)
    ];
  };
  bindMouse = key: action: {
    _args = [
      key
      (lua action)
      { mouse = true; }
    ];
  };
  exec = key: command: bind key ''hl.dsp.exec_cmd("${command}")'';
  # Works on the lock screen and repeats while held.
  media = key: command: {
    _args = [
      key
      (lua ''hl.dsp.exec_cmd("${command}")'')
      {
        locked = true;
        repeating = true;
      }
    ];
  };

  direction = key: name: { inherit key name; };
  directions = [
    (direction "H" "l")
    (direction "J" "d")
    (direction "K" "u")
    (direction "L" "r")
  ];

  workspaceKeys = [
    "Q"
    "W"
    "E"
    "R"
    "U"
    "I"
    "O"
    "P"
  ];
in
{
  wayland.windowManager.hyprland.settings.bind = [
    # Control tiling
    (bind "SUPER + C" "hl.dsp.window.close()")
    (bind "SUPER + semicolon" ''hl.dsp.layout("togglesplit")'')
    (bind "SUPER + V" ''hl.dsp.window.float({ action = "toggle" })'')
    (bind "SUPER + D" ''hl.dsp.window.fullscreen({ mode = "maximized" })'')

    # Float, center and pin the window on every workspace; press again to tile it back.
    (bind "SUPER + A" ''
      function()
        local window = hl.get_active_window()
        if not window then return end
        if window.pinned then
          hl.dispatch(hl.dsp.window.pin())
          hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
        else
          if not window.floating then
            hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
          end
          hl.dispatch(hl.dsp.window.resize({ x = 1300, y = 900 }))
          hl.dispatch(hl.dsp.window.center())
          hl.dispatch(hl.dsp.window.pin())
        end
      end
    '')

    # Jump back and forth between the current and the previous window.
    (bind "ALT + TAB" "hl.dsp.focus({ last = true })")

    # Move and resize with the mouse
    (bindMouse "SUPER + mouse:272" "hl.dsp.window.drag()")
    (bindMouse "SUPER + mouse:273" "hl.dsp.window.resize()")

    # Resize active window
    (bind "SUPER + CTRL + H" "hl.dsp.window.resize({ x = -100, y = 0, relative = true })")
    (bind "SUPER + CTRL + J" "hl.dsp.window.resize({ x = 0, y = 100, relative = true })")
    (bind "SUPER + CTRL + K" "hl.dsp.window.resize({ x = 0, y = -100, relative = true })")
    (bind "SUPER + CTRL + L" "hl.dsp.window.resize({ x = 100, y = 0, relative = true })")

    # Move between workspaces
    (bind "SUPER + TAB" ''hl.dsp.focus({ workspace = "e+1" })'')
    (bind "SUPER + ESCAPE" ''hl.dsp.focus({ workspace = "e-1" })'')

    # Scratchpad: a hidden workspace shown on top of the current one
    (bind "SUPER + S" ''hl.dsp.workspace.toggle_special("scratchpad")'')
    (bind "SUPER + ALT + S" ''hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })'')

    # Applications
    (exec "SUPER + RETURN" "ghostty")
    (exec "SUPER + SHIFT + RETURN" "firefox")
    (exec "SUPER + F" "nautilus --new-window")
    (exec "SUPER + N" "neovide")

    # Utilities
    (exec "SUPER + SPACE" "rofi -show drun")
    (exec "SUPER + PERIOD" "rofi -show emoji")
    (exec "SUPER + CTRL + V" "clipboard")

    # Captures
    (exec "SUPER + SHIFT + S" "omasnap")
    (exec "SUPER + SHIFT + D" "screenrecord")
    (exec "SUPER + SHIFT + C" "pkill hyprpicker || hyprpicker -a")

    # Volume
    (media "XF86AudioRaiseVolume" "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")
    (media "XF86AudioLowerVolume" "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
    (media "XF86AudioMute" "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
    (media "XF86AudioMicMute" "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
  ]
  ++ map (d: bind "SUPER + ${d.key}" ''hl.dsp.focus({ direction = "${d.name}" })'') directions
  ++ map (
    d: bind "SUPER + SHIFT + ${d.key}" ''hl.dsp.window.swap({ direction = "${d.name}" })''
  ) directions
  ++ lib.imap1 (
    i: key: bind "SUPER + ${key}" ''hl.dsp.focus({ workspace = "${toString i}" })''
  ) workspaceKeys
  ++ lib.imap1 (
    i: key: bind "SUPER + SHIFT + ${key}" ''hl.dsp.window.move({ workspace = "${toString i}" })''
  ) workspaceKeys;
}
