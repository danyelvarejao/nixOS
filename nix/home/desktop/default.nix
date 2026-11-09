{ ... }:
{
  imports = [
    ../common.nix
    ./hyprland.nix
  ];

  # Set this to the NixOS release used on installation day, then never change it.
  home.stateVersion = "26.05";
}
