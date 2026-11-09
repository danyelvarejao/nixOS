{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    theme = "material";
    plugins = [
      pkgs.rofi-emoji
      pkgs.rofi-calc
    ];
    settings = {
      modes = [
        "drun"
        "window"
        "run"
        "emoji"
        "calc"
      ];
      font = "JetBrains Mono 17";
    };
  };

  stylix.targets.rofi.enable = false;
}
