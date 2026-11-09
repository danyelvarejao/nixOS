{ pkgs, ... }:
{
  programs.localsend.enable = true;

  environment.systemPackages = with pkgs; [
    # Files and viewers
    evince # pdf viewer
    feh
    gthumb
    nautilus
    qimgv # image viewer

    # Media
    gimp
    kdePackages.kdenlive
    playerctl
    spotify
    vlc

    # Office
    libreoffice

    # Communication and notes
    bitwarden-cli
    bitwarden-desktop
    discord
    obsidian
  ];
}
