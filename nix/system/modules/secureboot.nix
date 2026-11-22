# Secure Boot with my own keys (plus Microsoft's, so Windows and Vanguard keep working).
# Lanzaboote signs systemd-boot and every generation's UKI on each rebuild.
# Keys live in /var/lib/sbctl (sudo sbctl create-keys) and must exist before the first rebuild.
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Reboot once into Windows Boot Manager; the next boot falls back to NixOS.
  reboot-windows = pkgs.writeShellApplication {
    name = "reboot-windows";
    runtimeInputs = [
      pkgs.efibootmgr
      pkgs.gnugrep
      pkgs.gnused
      pkgs.systemd
    ];
    text = ''
      entry=$(efibootmgr | grep -m1 'Windows Boot Manager' | sed -E 's/^Boot([0-9A-Fa-f]{4}).*/\1/' || true)
      if [ -z "$entry" ]; then
        echo "Windows Boot Manager not found in the firmware boot entries." >&2
        exit 1
      fi
      sudo efibootmgr --bootnext "$entry" >/dev/null
      systemctl reboot
    '';
  };
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  # Lanzaboote installs its own signed systemd-boot.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.efibootmgr
    reboot-windows
  ];
}
