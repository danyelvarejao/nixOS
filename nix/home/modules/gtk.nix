{ lib, pkgs, ... }:
{
  gtk.enable = true;
  gtk.theme = lib.mkForce {
    name = "adw-gtk3-dark";
    package = pkgs.adw-gtk3;
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = lib.mkForce "prefer-dark";

  home.pointerCursor.enable = true;
}
