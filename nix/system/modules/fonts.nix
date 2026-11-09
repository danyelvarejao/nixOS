{ pkgs, ... }:
{
  # more in stylix.nix
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];
}
