{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.custom.dotfiles = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/Projects/nixOS";
    description = "Where this repository is checked out.";
  };

  imports = [
    ./modules/cli.nix
    ./modules/git.nix
    ./modules/keyring.nix
    ./modules/lazygit.nix
    ./modules/mpv.nix
    ./modules/neovim.nix
    ./modules/ssh.nix
    ./modules/stream.nix
    ./modules/xdg.nix
    ./modules/zsh.nix
  ];

  config = {
    home = rec {
      username = "danyel";
      homeDirectory = "/home/${username}";
      packages = with pkgs; [
        screenrecord
        screenshot
      ];
      sessionPath = [
        "$HOME/.local/bin"
        "$HOME/.cargo/bin"
      ];
    };

    programs.home-manager.enable = true;
  };
}
