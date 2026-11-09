pkgs: {
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    runtimeInputs = with pkgs; [
      grim
      libnotify
      slurp
      wl-clipboard
    ];
    text = builtins.readFile ../../scripts/screenshot;
  };

  # gpu-screen-recorder comes from PATH: NixOS wraps it with the capability it needs.
  screenrecord = pkgs.writeShellApplication {
    name = "screenrecord";
    runtimeInputs = with pkgs; [
      libnotify
      procps
    ];
    text = builtins.readFile ../../scripts/screenrecord;
  };
}
