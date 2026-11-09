{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    hyprshade
  ];

  wayland.windowManager.hyprland.settings.on = [
    {
      _args = [
        "hyprland.start"
        (lib.generators.mkLuaInline ''function() hl.exec_cmd("hyprshade auto") end'')
      ];
    }
  ];

  home.file.".config/hyprshade/config.toml".text = ''
    [[shades]]
    name = "vibrance"
    default = true

    [[shades]]
    name = "blue-light-filter"
    start_time = 19:00:00
    end_time = 06:00:00
  '';
}
