# Adding a host

A host is one machine. It has two directories with the same name:

- `nix/system/<host>/` for NixOS: disk, hardware and machine-specific services.
- `nix/home/<host>/` for Home Manager: monitors and other per-machine desktop settings.

The flake turns every `nix/system/<host>/` that contains a `hardware.nix` into
`nixosConfigurations.<host>`. That file is generated on installation day, so a new host only
appears once it exists.

Use `desktop` (a real PC) and `nixos-test` (a VM) as examples.

## 1. System

Create `nix/system/<host>/default.nix`:

```nix
{ ... }:
{
  imports = [
    ./hardware.nix
    (import ../modules/disk.nix {
      # Find yours with: ls -l /dev/disk/by-id/
      device = "/dev/disk/by-id/nvme-YOUR_DISK_MODEL_AND_SERIAL";
      swapSize = "16G";
    })
    ../modules/common.nix # system, desktop and browser
    ../modules/development.nix # languages, IDEs, containers
    ../modules/apps.nix # desktop apps and games
  ];

  networking.hostName = "<host>";

  # The NixOS release you install, then never change it.
  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
```

Refer to the disk by `/dev/disk/by-id/`, not `/dev/nvme0n1`: the ID names one physical drive, so
disko can never erase a different one. A VM's virtio disk has no ID unless it has a serial number;
use `/dev/vda` there, as `nixos-test` does. `disk.nix` erases the whole disk and creates an ESP, swap
and an unencrypted ext4 root.

Every host runs an SSH server that only accepts the keys in `vars.sshKeys`; passwords and root
logins are refused.

Drop `development.nix` or `apps.nix` to leave those packages out. For hardware quirks, add a module
from [nixos-hardware](https://github.com/NixOS/nixos-hardware), as `desktop` does.

## 2. Home

Create `nix/home/<host>/default.nix`:

```nix
{ ... }:
{
  imports = [ ../common.nix ];

  wayland.windowManager.hyprland.settings.monitor = [
    {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = 1;
    }
  ];

  # Same release as system.stateVersion.
  home.stateVersion = "26.05";
}
```

Run `hyprctl monitors` once Hyprland is running to see your monitor's modes.

## 3. Install

Follow [nixos-install.md](nixos-install.md). Generating `hardware.nix` is one of its steps.
