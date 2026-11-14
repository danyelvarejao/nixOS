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
    _7zz # 7-Zip
    cryptsetup # LUKS volumes
    dtrx
    dua # interactive disk usage
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
    yt-dlp

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
    netcat-openbsd
    rclone
    socat
    trippy # network diagnostic
    unixtools.netstat
    wget
    whois

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

  # Power profiles for the ashell PowerProfile indicator.
  services.power-profiles-daemon.enable = true;

  # Never suspend when the lid closes; the power key keeps systemd's default (power off).
  services.logind.settings.Login.HandleLidSwitch = "ignore";

  # Automount removable media.
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
}
