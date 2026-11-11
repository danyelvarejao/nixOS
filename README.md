# Danyel's NixOS config

My [NixOS](https://nixos.org/) configuration, written as a flake with
[Home Manager](https://github.com/nix-community/home-manager). You are welcome to fork it and make
it yours.

## What you get

- Hyprland with UWSM, started from the first TTY, with ashell as the bar and rofi as the launcher
- Catppuccin Mocha everywhere through [Stylix](https://github.com/nix-community/stylix)
- Ghostty, zsh with starship, fzf, zoxide and eza
- Neovim with LazyVim, plus Neovide
- Disks declared with [disko](https://github.com/nix-community/disko): ESP, swap and ext4
- Development tools, Docker, libvirt, Steam and desktop apps

## Layout

- `flake.nix` is the entry point. Its `vars` block holds every personal setting.
- `nix/system/` is the NixOS configuration: shared `modules/` and one directory per host.
- `nix/home/` is the Home Manager configuration: shared `modules/` and one directory per host.
- `nix/pkgs/` and `nix/overlays/` add and patch packages.
- `nvim/` is the Neovim configuration, linked to `~/.config/nvim` so it stays editable.
- `danyel.pub` is my public SSH key.
- `doc/` has the guides.

## Make it yours

1. Fork the repository.
2. Edit the `vars` block in `flake.nix`: user name, Git identity, SSH keys, time zone, locale and
   keyboard.
3. Replace `danyel.pub` with your public SSH key, or point `vars.sshKeys` at yours.
4. Add a host for your machine, as described in [doc/adding-a-host.md](doc/adding-a-host.md). The
   `desktop` host is my PC; use it as an example.
5. Install with [doc/nixos-install.md](doc/nixos-install.md).

To try it first, `nixos-test` is a host for a libvirt VM.

## License

[MIT](LICENSE)
