{ ... }:
{
  imports = [
    ../common.nix
    ../modules/hyprland
  ];

  # The virtual GPU does not support hardware cursors.
  wayland.windowManager.hyprland.settings.config.cursor.no_hardware_cursors = true;

  home.stateVersion = "26.05";
}
