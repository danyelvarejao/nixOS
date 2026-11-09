{ ... }:
let
  dialog = name: match: {
    inherit name match;
    float = true;
    center = true;
    size = [
      875
      600
    ];
  };
in
{
  wayland.windowManager.hyprland.settings.window_rule = [
    {
      name = "ignore-maximize-requests";
      match.class = ".*";
      suppress_event = "maximize";
    }
    {
      # Invisible XWayland helper windows must not steal focus.
      name = "ignore-empty-xwayland";
      match = {
        class = "^$";
        title = "^$";
        xwayland = true;
        float = true;
        fullscreen = false;
        pin = false;
      };
      no_focus = true;
    }

    # Dialogs
    (dialog "portal-dialog" { class = "xdg-desktop-portal-gtk"; })
    (dialog "floating-viewers" { class = "(org.gnome.NautilusPreviewer|org.gnome.Evince|imv|mpv)"; })
    (dialog "file-dialogs" {
      class = "(sublime_text|DesktopEditors|org.gnome.Nautilus)";
      title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)";
    })

    # Bitwarden
    (
      dialog "bitwarden" { class = "^([bB]itwarden)$"; }
      // {
        no_screen_share = true;
      }
    )
    {
      name = "bitwarden-extension";
      match.class = ".*nngceckbapebfimnlniiiahkandclblb.*";
      no_screen_share = true;
      float = true;
      center = true;
    }

    # Browsers
    {
      name = "tile-chromium";
      match.class = "((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium)";
      tile = true;
    }
    {
      name = "hide-sharing-indicator";
      match.title = ".*is sharing.*";
      workspace = "special silent";
    }
    {
      name = "picture-in-picture";
      match.title = "(Picture.?in.?[Pp]icture)";
      float = true;
      pin = true;
      size = [
        600
        338
      ];
      keep_aspect_ratio = true;
      border_size = 0;
      move = [
        "(monitor_w-window_w-40)"
        "(monitor_h*0.04)"
      ];
    }

    # JetBrains IDEs
    {
      name = "jetbrains";
      match.class = "^(jetbrains-.*)$";
      no_follow_mouse = true;
    }

    # Steam
    {
      name = "steam";
      match.class = "steam";
      float = true;
      idle_inhibit = "fullscreen";
    }
    {
      name = "steam-main";
      match = {
        class = "steam";
        title = "Steam";
      };
      center = true;
      size = [
        1100
        700
      ];
    }
    {
      name = "steam-friends";
      match = {
        class = "steam";
        title = "Friends List";
      };
      size = [
        460
        800
      ];
    }

    # LocalSend
    {
      name = "localsend";
      match.class = "(org\\.localsend\\.)?localsend(_app)?";
      float = true;
      center = true;
      size = [
        1100
        700
      ];
    }

    # Android Studio emulator opens floating; transparency breaks its colors.
    {
      name = "android-emulator";
      match.class = "^(Emulator)$";
      float = true;
      rounding = 0;
      opacity = "1.0 override";
    }

    # Always opaque
    {
      name = "opaque-firefox";
      match.class = "firefox";
      opacity = "1.0 override";
    }
    {
      name = "opaque-mpv";
      match.class = "mpv";
      opacity = "1.0 override";
    }
  ];

  wayland.windowManager.hyprland.settings.layer_rule = [
    {
      name = "blur-rofi";
      match.namespace = "rofi";
      blur = true;
    }
    {
      name = "blur-notifications";
      match.namespace = "notifications";
      blur = true;
    }
    {
      name = "omasnap";
      match.namespace = "^omasnap$";
      no_anim = true;
      animation = "none";
    }
  ];
}
