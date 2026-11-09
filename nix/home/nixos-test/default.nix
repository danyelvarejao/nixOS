{ ... }:
{
  imports = [
    ../common.nix
    ../modules/hyprland
  ];

  # The virtual GPU does not support hardware cursors.
  wayland.windowManager.hyprland.settings = {
    config.cursor.no_hardware_cursors = true;

    monitor = [
      {
        output = "";
        mode = "3840x2160@60";
        position = "auto";
        scale = "1.5";
      }
    ];
  };

  home.stateVersion = "26.05";
}
