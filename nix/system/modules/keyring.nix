# GNOME Keyring for app secrets (browsers, VSCode, Discord), unlocked at login through PAM.
{ ... }:
{
  services.gnome.gnome-keyring.enable = true;

  # SSH keys stay with the ssh-agent user service, see home/modules/ssh.nix.
  services.gnome.gcr-ssh-agent.enable = false;
}
