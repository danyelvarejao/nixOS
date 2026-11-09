# Terminal programs that open from rofi as their own floating window.
{ lib, ... }:
let
  apps = {
    dua = {
      name = "Disk Usage";
      command = "dua i";
      icon = "drive-harddisk";
    };
  };

  class = id: "dev.danyel.${id}";
in
{
  xdg.desktopEntries = lib.mapAttrs (id: app: {
    inherit (app) name icon;
    genericName = id;
    exec = "ghostty --class=${class id} --working-directory=home -e ${app.command}";
    categories = [ "Utility" ];
    settings.StartupWMClass = class id;
  }) apps;

  wayland.windowManager.hyprland.settings.window_rule = lib.mapAttrsToList (id: _: {
    name = "tui-${id}";
    match.class = "^${lib.escapeRegex (class id)}$";
    float = true;
    center = true;
    size = [
      1100
      700
    ];
  }) apps;
}
