{ inputs, pkgs }:
{
  omasnap = pkgs.callPackage ./omasnap.nix { src = inputs.omasnap; };

  # gpu-screen-recorder comes from PATH: NixOS wraps it with the capability it needs.
  # rofi, hyprctl, mpv and nautilus also come from PATH (user and system profiles).
  screenrecord = pkgs.writeShellApplication {
    name = "screenrecord";
    runtimeInputs = with pkgs; [
      jq
      libnotify
      procps
      slurp
      wl-clipboard
    ];
    text = builtins.readFile ../../scripts/screenrecord;
  };

  # rofi comes from PATH: Home Manager builds it with the plugins and settings.
  clipboard = pkgs.writeShellApplication {
    name = "clipboard";
    runtimeInputs = with pkgs; [
      cliphist
      wl-clipboard
    ];
    text = builtins.readFile ../../scripts/clipboard;
  };
}
