# desktop is my main PC; hardware.nix is generated during installation
{ inputs, lib, ... }:
{
  imports = [
    ./hardware.nix
    (import ../modules/disk.nix {
      # The 954 GB XPG drive. The Windows WD_BLACK drive is never referenced here.
      device = "/dev/disk/by-id/nvme-XPG_GAMMIX_S70_BLADE_2P47291792F9";
      swapSize = "32G";
    })
    inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    ../modules/common.nix
    ../modules/development.nix
    ../modules/apps.nix
    ../modules/razer.nix
  ];

  networking.hostName = "desktop";

  networking.networkmanager.ensureProfiles.profiles.wired = {
    connection = {
      id = "wired";
      type = "ethernet";
      interface-name = "eno1";
      autoconnect = true;
    };
    ipv4 = {
      method = "manual";
      address1 = "192.168.0.14/24,192.168.0.1";
      dns = "1.1.1.1;1.0.0.1;8.8.8.8;8.8.4.4;";
    };
    ipv6.method = "auto";
  };

  stylix.fonts.sizes = lib.mkForce {
    applications = 14;
    desktop = 14;
    popups = 14;
    terminal = 13;
  };

  # Set this to the NixOS release used on installation day, then never change it.
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
