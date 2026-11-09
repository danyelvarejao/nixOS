{ pkgs, ... }:
{
  virtualisation.docker.enable = true;

  users.users.danyel.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [ lazydocker ];
}
