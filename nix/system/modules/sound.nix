{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ pavucontrol ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };
}
