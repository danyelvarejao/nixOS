{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    iw
  ];

  networking = {
    firewall.enable = true;
    nftables.enable = true;
    networkmanager.enable = true;
    useDHCP = false;
    dhcpcd.enable = false;
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
  };
}
