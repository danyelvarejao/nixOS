{ lib, ... }:
let
  curve = name: x0: y0: x1: y1: {
    _args = [
      name
      {
        type = "bezier";
        points = [
          [
            x0
            y0
          ]
          [
            x1
            y1
          ]
        ];
      }
    ];
  };
  animation =
    leaf: speed: bezier: style:
    {
      inherit leaf speed bezier;
      enabled = true;
    }
    // lib.optionalAttrs (style != null) { inherit style; };
  noAnimation = leaf: {
    inherit leaf;
    enabled = false;
    speed = 1.94;
    bezier = "almostLinear";
  };
in
{
  services.hyprpaper.enable = true;
  stylix.targets.hyprland.hyprpaper.enable = true;

  wayland.windowManager.hyprland.settings = {
    config = {
      general = {
        gaps_in = 8;
        gaps_out = {
          top = 21;
          right = 21;
          bottom = 7;
          left = 21;
        };
        border_size = 0;
      };

      decoration = {
        rounding = 24;
        rounding_power = 2;
        blur = {
          enabled = true;
          size = 3;
          passes = 2;
        };
        shadow = {
          enabled = true;
          range = 30;
          render_power = 4; # Hyprland's maximum; ornicar's config asks for 5
          color = lib.mkForce "rgba(255,255,255,0.03)";
          color_inactive = "rgba(0,0,0,0.6)";
        };
        glow = {
          enabled = true;
          range = 5;
          color = "rgba(255,255,255,0.3)";
        };
        active_opacity = 0.95;
        inactive_opacity = 0.8;
        dim_inactive = false;
        dim_strength = 0.05;
      };

      animations.enabled = true;
    };

    curve = [
      (curve "easeOutQuint" 0.23 1 0.32 1)
      (curve "easeInOutCubic" 0.65 5.0e-2 0.36 1)
      (curve "linear" 0 0 1 1)
      (curve "almostLinear" 0.5 0.5 0.75 1)
      (curve "quick" 0.15 0 0.1 1)
    ];

    animation = [
      (animation "global" 10 "default" null)
      (animation "border" 5.39 "easeOutQuint" null)
      (animation "windows" 4.79 "easeOutQuint" null)
      (animation "windowsIn" 4.1 "easeOutQuint" "popin 80%")
      (animation "windowsOut" 1.49 "linear" "popin 80%")
      (animation "fadeIn" 1.73 "almostLinear" null)
      (animation "fadeOut" 1.46 "almostLinear" null)
      (animation "fade" 3.03 "quick" null)
      (animation "layers" 3.81 "easeOutQuint" null)
      (animation "layersIn" 4 "easeOutQuint" "fade")
      (animation "layersOut" 1.5 "linear" "fade")
      (animation "fadeLayersIn" 1.79 "almostLinear" null)
      (animation "fadeLayersOut" 1.39 "almostLinear" null)
      (noAnimation "workspaces")
      (noAnimation "workspacesIn")
      (noAnimation "workspacesOut")
      (animation "zoomFactor" 7 "quick" null)
    ];
  };
}
