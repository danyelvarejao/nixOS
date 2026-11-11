# Installing NixOS

How to install a host from scratch. **This erases the host's whole disk.**

Create the host first, as described in [adding-a-host.md](adding-a-host.md). Below, replace
`<host>` with its name and `<user>` with `vars.user` from `flake.nix`.

Other disks are never touched: the configuration only names the disk set in the host's
`default.nix`. A second operating system on another disk stays available from the firmware's boot
menu.

## Disk layout

Defined in `nix/system/modules/disk.nix`:

| Partition | Size              | File system |
| --------- | ----------------- | ----------- |
| ESP       | 1 GB              | FAT32       |
| swap      | the host's choice | swap        |
| root      | the rest          | ext4        |

The disk is not encrypted.

## What you need

- A USB drive with the NixOS ISO.
- Internet access during the installation.
- Secure Boot turned off.

## Installation

Boot from the USB drive and become root with `sudo -i`.

### 1. Check the disk

```sh
ls -l /dev/disk/by-id/
```

The disk set in `nix/system/<host>/default.nix` must be listed. If it is not, stop: the
configuration does not match this machine.

In a VM, a virtio disk without a serial number has no entry here; the host uses `/dev/vda`
instead, and `lsblk` confirms it.

### 2. Clone the repository

```sh
git clone https://github.com/<you>/nixOS /tmp/nixOS
cd /tmp/nixOS
```

For a private repository, run `nix-shell -p gh --run 'gh auth login'` first and clone with
`gh repo clone`.

### 3. Generate the hardware configuration

```sh
nixos-generate-config --no-filesystems --show-hardware-config \
  > nix/system/<host>/hardware.nix
git add nix/system/<host>/hardware.nix
```

Without `git add`, the flake does not see the file and `<host>` does not exist.

### 4. Set `stateVersion`

In `nix/system/<host>/default.nix` and `nix/home/<host>/default.nix`, use the release of the ISO
you are installing. Never change it afterwards.

```sh
git add -A
```

### 5. Erase, partition and mount the disk

```sh
nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake .#<host>
```

disko asks for confirmation before erasing.

### 6. Install

```sh
nixos-install --no-root-passwd --no-channel-copy --flake .#<host>
nixos-enter --root /mnt -c 'passwd <user>'
```

### 7. Copy the repository and reboot

The configuration expects the repository at `~/Projects/nixOS`; `custom.dotfiles` in
`nix/home/common.nix` changes that.

```sh
mkdir -p /mnt/home/<user>/Projects
cp -a /tmp/nixOS /mnt/home/<user>/Projects/nixOS
chown -R 1000:100 /mnt/home/<user>/Projects
reboot
```

Remove the USB drive. In the firmware, put **Linux Boot Manager** first.

## First boot

Log in on TTY1; Hyprland starts right after. Open a terminal and save the generated hardware:

```sh
gh auth login
cd ~/Projects/nixOS
git add -A
git commit -m "Add the <host> hardware"
git push
```

Apply later changes with `nswitch` (`nh os switch`).

Private SSH hosts go in `~/.ssh/config.local` and private shell settings in `~/.zshrc.local`; both
stay out of Git.

## If something goes wrong

- In the `systemd-boot` menu, pick an earlier generation.
- To repair from the USB drive, mount the system again and enter it:

```sh
cd /tmp/nixOS
nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode mount --flake .#<host>
nixos-enter --root /mnt
```
