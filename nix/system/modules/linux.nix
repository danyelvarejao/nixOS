{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bc # calculator
    bind
    curl
    dmidecode
    dtrx
    dust
    fastfetch
    fd
    ffmpeg
    file
    fx # tui json viewer
    git
    gping # ping with a graph
    htop
    httpie
    imagemagick
    iprange
    jq
    lm_sensors
    lsof
    mosh
    pciutils
    ps_mem
    psmisc # fuser
    rsync
    trippy # network diagnostic
    unixtools.netstat
    unixtools.xxd
    unzip
    usbutils
    wget
    zip
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
