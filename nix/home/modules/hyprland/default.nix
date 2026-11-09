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
  ];

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
          follow_mouse = 2;
          touchpad = {
            natural_scroll = true;
            clickfinger_behavior = true;
            scroll_factor = 0.4;
            disable_while_typing = false;
            drag_3fg = 1;
          };
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
