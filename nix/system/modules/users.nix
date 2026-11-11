{ vars, ... }:
{
  users.users.${vars.user} = {
    isNormalUser = true;
    description = vars.fullName;
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
    ];
    openssh.authorizedKeys.keyFiles = vars.sshKeys;
  };

  security.sudo = {
    execWheelOnly = true;
    wheelNeedsPassword = true;
    extraConfig = ''
      Defaults        timestamp_timeout=600
    '';
  };
}
