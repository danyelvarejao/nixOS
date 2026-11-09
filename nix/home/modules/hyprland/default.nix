{ lib, ... }:
{
  imports = [
    ../ashell.nix
    ../ghostty.nix
    ../hyprshade.nix
    ../wayland.nix
    ./idle.nix
    ./keybinds.nix
    ./look.nix
    ./rules.nix
  ];

  services.hyprpolkitagent.enable = true;

  # Start the desktop after logging in on the first TTY.
  programs.zsh.profileExtra = ''
    if uwsm check may-start; then
      exec uwsm start hyprland-uwsm.desktop
    fi
  '';

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # https://wiki.nixos.org/wiki/Hyprland
    configType = "lua"; # Hyprland 0.57 only loads hyprland.lua
    settings = {
      config = {
        input = {
          kb_layout = "us";
          kb_variant = "intl";
          repeat_rate = 50;
          repeat_delay = 150;
          sensitivity = 0;
          accel_profile = "flat";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = true;
            clickfinger_behavior = true;
            scroll_factor = 0.4;
            disable_while_typing = false;
            drag_3fg = 1;
          };
        };

        cursor.no_warps = true;

        # New windows always open to the right or below, as in Omarchy.
        dwindle = {
          force_split = 2;
          preserve_split = true;
        };

        xwayland.force_zero_scaling = true;

        misc = {
          disable_splash_rendering = true;
          key_press_enables_dpms = true;
        };

        ecosystem = {
          no_update_news = true;
          no_donation_nag = true;
        };
      };

      monitor = lib.mkDefault [
        {
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
        }
      ];
    };
  };
}
