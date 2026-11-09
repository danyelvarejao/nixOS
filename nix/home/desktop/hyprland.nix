{ lib, ... }:
{
  imports = [ ../modules/hyprland ];

  wayland.windowManager.hyprland.settings = {
    config.general = {
      gaps_in = lib.mkForce 15;
      gaps_out = lib.mkForce {
        top = 27;
        right = 27;
        bottom = 5;
        left = 27;
      };
    };
    monitor = [
      {
        output = "";
        mode = "3840x2160@240";
        position = "auto";
        scale = "1.5";
      }
    ];
    env = [
      {
        _args = [
          "GDK_SCALE"
          "2"
        ];
      }
    ];
  };

  programs.ashell.settings = {
    system_info.temperature.sensor = "k10temp Tctl";
    media_player.max_title_length = 100;
  };
}
