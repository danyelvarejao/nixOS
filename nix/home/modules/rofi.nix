{ config, pkgs, ... }:
let
  inherit (config.lib.formats.rasi) mkLiteral;
in
{
  programs.rofi = {
    enable = true;
    # Material, made compact: narrower window and a list that shrinks to fit short menus.
    theme = {
      "@theme" = "material";
      window.width = mkLiteral "30%";
      listview = {
        lines = 8;
        fixed-height = false;
      };
    };
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
      font = "${config.stylix.fonts.monospace.name} 13";
    };
  };

  stylix.targets.rofi.enable = false;
}
