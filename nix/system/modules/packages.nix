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
    # FreeRDP 3.33 drops Windows 7 sessions: Windows 7 pads bitmap widths to a multiple of 4
    # ("Invalid BITMAP_DATA: width=36 != right - left=34"), and the spec allows it.
    (freerdp.overrideAttrs (old: {
      postPatch = (old.postPatch or "") + ''
        substituteInPlace libfreerdp/core/update.c \
          --replace-fail 'if (w != bitmapData->width - 1)' 'if (w > bitmapData->width - 1)' \
          --replace-fail 'if (h != bitmapData->height - 1)' 'if (h > bitmapData->height - 1)'
      '';
    }))
    wineWow64Packages.stable
  ];
}
