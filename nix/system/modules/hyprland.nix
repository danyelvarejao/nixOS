{ ... }:
{
  imports = [ ./wayland.nix ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Sets up the PAM service that lets hyprlock unlock the session.
  programs.hyprlock.enable = true;
}
