{ lib, pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];

  environment.systemPackages = with pkgs; [
    ast-grep
    bat-extras.batman
    bat-extras.batwatch
    chafa # terminal image viewer
    cmatrix
    devenv
    figlet
    nushell
    pinentry-tty
    systemctl-tui
    sysz
    tree
  ];

  # SSH keys stay with the ssh-agent user service, see home/modules/ssh.nix.
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-tty;
  };

  programs.zsh = {
    # Required for the root user.
    enable = true;
    # zsh picks vi mode when EDITOR contains "vi". This option runs before /etc/zinputrc,
    # so the Home, End, Delete and PageUp/Down bindings land on the emacs keymap.
    setOptions = lib.mkOptionDefault [ "EMACS" ];
  };
}
