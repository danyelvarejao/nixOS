{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Terminal
    bat-extras.batman
    bat-extras.batwatch
    bc # calculator
    chafa # terminal image viewer
    cmatrix
    fastfetch
    figlet
    nushell
    tree

    # Files
    dtrx
    dust
    fd
    file
    rsync
    unzip
    zip

    # Data and media
    ffmpeg
    fx # tui json viewer
    imagemagick
    jq
    unixtools.xxd

    # Development
    ast-grep
    devenv
    git

    # Network
    bind
    curl
    gping # ping with a graph
    httpie
    iprange
    mosh
    trippy # network diagnostic
    unixtools.netstat
    wget

    # Processes and services
    htop
    lsof
    ps_mem
    psmisc # fuser
    systemctl-tui
    sysz

    # Hardware
    dmidecode
    lm_sensors
    pciutils
    usbutils
  ];

  # Enable zsh completion for system packages.
  environment.pathsToLink = [ "/share/zsh" ];

  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    HandleLidSwitch = "suspend";
  };

  # Automount removable media.
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
