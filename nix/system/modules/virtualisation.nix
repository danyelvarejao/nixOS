{ ... }:
{
  virtualisation.libvirtd = {
    enable = true;
    # Software TPM, required by Windows 11 guests.
    qemu.swtpm.enable = true;
  };
  programs.virt-manager.enable = true;

  users.users.danyel.extraGroups = [ "libvirtd" ];
}
