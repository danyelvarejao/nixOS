{ pkgs, ... }:
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

  # Required for the root user.
  programs.zsh.enable = true;
}
