# desktop is my main PC; hardware.nix is generated during installation
{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    (import ../modules/disk.nix {
      # The 1 TB WD_BLACK drive. disko erases it on install.
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN850X_1000GB_233232801744";
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

  # GPU firmware and CPU microcode from linux-firmware.
  hardware.enableRedistributableFirmware = true;

  # Firmware updates for the SSD, peripherals and motherboard: fwupdmgr update
  services.fwupd.enable = true;

  # Keep USB audio and input devices awake.
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

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
      dns = lib.concatMapStrings (server: "${server};") config.networking.nameservers;
    };
    ipv6.method = "auto";
  };

  stylix.fonts.sizes = lib.mkForce {
    applications = 11;
    desktop = 11;
    popups = 11;
    terminal = 11;
  };

  # Set this to the NixOS release used on installation day, then never change it.
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
