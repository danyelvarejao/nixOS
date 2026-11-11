{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
{
  options.custom.dotfiles = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Projects/nixOS";
    description = "Where this repository is checked out.";
  };

  imports = [
    ./modules/ashell.nix
    ./modules/cli.nix
    ./modules/ghostty.nix
    ./modules/git.nix
    ./modules/gtk.nix
    ./modules/hyprland
    ./modules/hyprshade.nix
    ./modules/keyring.nix
    ./modules/lazygit.nix
    ./modules/mpv.nix
    ./modules/nautilus.nix
    ./modules/neovim.nix
    ./modules/rofi.nix
    ./modules/ssh.nix
    ./modules/stream.nix
    ./modules/tui-apps.nix
    ./modules/wayland.nix
    ./modules/xcompose.nix
    ./modules/xdg.nix
    ./modules/zsh.nix
  ];

  config = {
    home = rec {
      username = vars.user;
      homeDirectory = "/home/${username}";
      packages = with pkgs; [
        clipboard
        omasnap
        screenrecord
      ];
      sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
      ];
    };

    programs.home-manager.enable = true;
  };
}
