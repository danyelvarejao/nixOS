# Base for every machine: system, desktop and browser.
{ outputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    outputs.overlays.additions
    outputs.overlays.modifications
  ];

  imports = [
    ./boot.nix
    ./browser.nix
    ./fonts.nix
    ./home-manager.nix
    ./hyprland.nix
    ./linux.nix
    ./locale.nix
    ./network.nix
    ./nix.nix
    ./shell.nix
    ./sound.nix
    ./ssh.nix
    ./stylix.nix
    ./users.nix
  ];

  services.dbus.enable = true;
  programs.dconf.enable = true;
}
