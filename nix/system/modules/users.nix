{ ... }:
{
  users.users.danyel = {
    isNormalUser = true;
    description = "Danyel";
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
    ];
    openssh.authorizedKeys.keyFiles = [ ./keys/danyel.pub ];
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      Defaults        timestamp_timeout=600
    '';
  };
}
