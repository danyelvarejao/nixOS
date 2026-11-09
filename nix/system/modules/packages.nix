{ pkgs, ... }:
{
  programs.localsend.enable = true;

  # Preview files in Nautilus with the space bar.
  services.gnome.sushi.enable = true;

  environment.systemPackages = with pkgs; [
    # Files and viewers
    evince # pdf viewer
    feh
    ffmpegthumbnailer # video thumbnails in Nautilus
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

    # Windows programs
    wineWow64Packages.stable
  ];
}
