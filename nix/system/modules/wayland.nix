{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    grim # screenshot
    hyprpicker
    libnotify
    slurp # visual region selection
    wayland
    wl-clipboard
    wlr-randr
    xdg-utils
  ];

  hardware.graphics.enable = true;

  programs.gpu-screen-recorder.enable = true;
}
