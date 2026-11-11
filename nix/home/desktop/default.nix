{ ... }:
{
  imports = [ ../common.nix ];

  wayland.windowManager.hyprland.settings = {
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

  # Set this to the NixOS release used on installation day, then never change it.
  home.stateVersion = "26.05";
}
