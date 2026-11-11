{ pkgs, vars, ... }:
{
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
  };

  environment.systemPackages = with pkgs; [ wireshark ];

  users.users.${vars.user}.extraGroups = [ "wireshark" ];
}
