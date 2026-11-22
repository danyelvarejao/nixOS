# Secure Boot that keeps the firmware on the ASUS factory keys, because Vanguard
# (STATUS_SB_POLICY) refuses a db with any extra certificate.
#
# Boot chain: firmware -> Ubuntu's Microsoft-signed shim -> systemd-boot (as grubx64.efi)
# -> Lanzaboote stub -> kernel. Lanzaboote signs systemd-boot and the stubs with the sbctl
# db key, which shim trusts once it is enrolled as a MOK (sudo mokutil --import).
# Keys live in /var/lib/sbctl (sudo sbctl create-keys) and must exist before the first rebuild.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  esp = config.boot.loader.efi.efiSysMountPoint;
  shimLabel = "NixOS (shim)";

  # shimx64.efi signed by Microsoft UEFI CA 2011, and MokManager signed by Canonical.
  shim =
    pkgs.runCommand "shim-signed-ubuntu-1.59"
      {
        src = pkgs.fetchurl {
          url = "https://launchpad.net/ubuntu/+archive/primary/+files/shim-signed_1.59+15.8-0ubuntu2_amd64.deb";
          hash = "sha256-+O1xzi2RowS21euEmX+EbzMbVUV4vALb/njhOtisgak=";
        };
        nativeBuildInputs = [ pkgs.dpkg ];
      }
      ''
        dpkg-deb -x $src deb
        install -Dm644 deb/usr/lib/shim/shimx64.efi.signed.latest $out/shimx64.efi
        install -Dm644 deb/usr/lib/shim/mmx64.efi $out/mmx64.efi
      '';

  # Runs Lanzaboote's installer, then puts shim next to a copy of the freshly signed
  # systemd-boot and keeps the shim entry first in the firmware boot order.
  lzbt = pkgs.writeShellApplication {
    name = "lzbt";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.efibootmgr
      pkgs.gnugrep
      pkgs.gnused
      pkgs.util-linux
    ];
    text = ''
      ${lib.getExe inputs.lanzaboote.packages.${pkgs.stdenv.hostPlatform.system}.lzbt} "$@"

      dir=${esp}/EFI/shim
      mkdir -p "$dir"
      install -m644 ${shim}/shimx64.efi ${shim}/mmx64.efi "$dir/"
      install -m644 ${esp}/EFI/systemd/systemd-bootx64.efi "$dir/grubx64.efi"

      ${lib.optionalString config.boot.loader.efi.canTouchEfiVariables ''
        entry() { efibootmgr | grep -F "${shimLabel}" | sed -E 's/^Boot([0-9A-Fa-f]{4}).*/\1/' | head -n1; }
        if [ -z "$(entry)" ]; then
          part=$(findmnt -no SOURCE ${esp})
          disk=/dev/$(lsblk -no PKNAME "$part")
          num=$(cat "/sys/class/block/$(basename "$part")/partition")
          efibootmgr --quiet --create --disk "$disk" --part "$num" \
            --label "${shimLabel}" --loader '\EFI\shim\shimx64.efi'
        fi
        id=$(entry)
        order=$(efibootmgr | sed -n 's/^BootOrder: //p')
        case "$order" in
          "$id"*) ;;
          *) efibootmgr --quiet --bootorder "$(echo "$id,$order" | sed -E "s/,$id(,|$)/\1/; s/,$//")" ;;
        esac
      ''}
    '';
  };

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
    package = lzbt;
  };

  environment.systemPackages = [
    pkgs.sbctl
    pkgs.mokutil
    pkgs.efibootmgr
    reboot-windows
  ];
}
