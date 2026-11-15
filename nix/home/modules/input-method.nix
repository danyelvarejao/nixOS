{ lib, vars, ... }:
let
  inherit (vars.keyboard) layout variant;
  im = "keyboard-${layout}-${variant}";

  # An empty INI section clears a key list; a missing one keeps fcitx5's default keys.
  noKeys = names: lib.genAttrs names (_: { });
in
{
  # The us-intl layout turns ' + c into ć; make it produce ç instead.
  home.file.".XCompose".text = ''
    include "%L"

    <dead_acute> <C> : "Ç" Ccedilla
    <dead_acute> <c> : "ç" ccedilla
  '';

  # Chromium and Electron on Wayland ignore ~/.XCompose and compose dead keys themselves (' + c is ć).
  # Through fcitx5 they get its compose, which reads ~/.XCompose. fcitx5 only carries the layout:
  # its hotkeys and the addons that have them are off, so app shortcuts reach the apps.
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;

    fcitx5.settings = {
      # Without it, fcitx5 starts with plain us and the dead keys are gone.
      inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "${layout}-${variant}";
          DefaultIM = im;
        };
        "Groups/0/Items/0".Name = im;
      };

      globalOptions = {
        "Behavior/DisabledAddons" = lib.listToAttrs (
          lib.imap0 (i: name: lib.nameValuePair (toString i) name) [
            "clipboard" # Ctrl+;
            "imselector" # Ctrl+Alt+Shift+digits
            "notificationitem" # tray icon
            "quickphrase" # Super+`
            "unicode" # Ctrl+Shift+U
          ]
        );
      }
      // noKeys [
        "Hotkey/TriggerKeys" # Ctrl+Space
        "Hotkey/AltTriggerKeys" # left Shift
        "Hotkey/EnumerateGroupForwardKeys" # Super+Space
        "Hotkey/EnumerateGroupBackwardKeys" # Shift+Super+Space
        "Hotkey/TogglePreedit" # Ctrl+Alt+P
      ];

      addons.keyboard.sections = noKeys [
        "Hint Trigger" # Ctrl+Alt+H
        "One Time Hint Trigger" # Ctrl+Alt+J
      ];
    };
  };
}
