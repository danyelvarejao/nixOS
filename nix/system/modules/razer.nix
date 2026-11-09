{ pkgs, ... }:
{
  hardware.openrazer = {
    enable = true;
    users = [ "danyel" ];
  };

  environment.systemPackages = with pkgs; [ polychromatic ];
}
