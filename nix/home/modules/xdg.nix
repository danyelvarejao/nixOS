{ lib, ... }:
{
  # for electron apps
  home.sessionVariables.DEFAULT_BROWSER = "firefox";

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications =
      let
        browser = "firefox.desktop";
        # Neovide, not nvim.desktop: GLib can't launch Terminal=true entries in ghostty.
        editor = [ "neovide.desktop" ];
        textTypes = [
          "text/plain"
          "text/markdown"
          "text/x-log"
          "text/csv"
          "text/x-python"
          "text/x-shellscript"
          "text/x-csrc"
          "text/x-chdr"
          "text/x-c++src"
          "text/x-c++hdr"
          "text/x-go"
          "text/x-lua"
          "text/x-nix"
          "text/rust"
          "text/javascript"
          "text/css"
          "text/x-makefile"
          "application/json"
          "application/x-shellscript"
          "application/javascript"
          "application/typescript"
          "application/xml"
          "application/yaml"
          "application/x-yaml"
          "application/toml"
          "application/x-desktop"
        ];
      in
      lib.genAttrs textTypes (_: editor)
      // {
        "text/html" = [ browser ];
        "x-scheme-handler/http" = [ browser ];
        "x-scheme-handler/https" = [ browser ];
        "x-scheme-handler/about" = [ browser ];
        "x-scheme-handler/unknown" = [ browser ];
        "application/pdf" = [
          "evince.desktop"
          browser
        ];

        "image/png" = [ "gthumb.desktop" ];
        "image/jpeg" = [ "gthumb.desktop" ];
        "image/gif" = [ "gthumb.desktop" ];

        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];

        "video/mp4" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];

        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      };
  };
}
