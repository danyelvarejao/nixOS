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

  ocr = pkgs.writeShellApplication {
    name = "ocr";
    runtimeInputs = with pkgs; [
      grim
      libnotify
      slurp
      (tesseract.override {
        enableLanguages = [
          "eng"
          "por"
        ];
      })
      wl-clipboard
    ];
    text = builtins.readFile ../../scripts/ocr;
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
