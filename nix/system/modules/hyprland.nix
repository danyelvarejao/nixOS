{ config, pkgs, ... }:
let
  # Catppuccin Mocha like the rest of the desktop (stylix.nix), over the same wallpaper.
  sddmTheme = pkgs.catppuccin-sddm.override {
    flavor = "mocha";
    accent = "mauve";
    font = config.stylix.fonts.sansSerif.name;
    fontSize = "12";
    background = config.stylix.image;
    loginBackground = true;
  };
in
{
  imports = [ ./wayland.nix ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # SDDM remembers the last user, so only the password is typed; it starts Hyprland through uwsm.
  services.displayManager = {
    defaultSession = "hyprland-uwsm";
    sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
      theme = "catppuccin-mocha-mauve";
    };
  };
  environment.systemPackages = [ sddmTheme ];
}
