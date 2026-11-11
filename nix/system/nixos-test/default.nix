# nixos-test is a disposable libvirt VM
{ lib, vars, ... }:
{
  imports = [
    ./hardware.nix
    (import ../modules/disk.nix {
      device = "/dev/vda";
      swapSize = "4G";
    })
    ../modules/common.nix
    ../modules/development.nix
    ../modules/apps.nix
  ];

  networking.hostName = "nixos-test";

  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Acceptable only on a disposable VM.
  services.getty.autologinUser = vars.user;
  users.users.${vars.user}.initialPassword = "nixos-test";
  security.sudo.wheelNeedsPassword = lib.mkForce false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
