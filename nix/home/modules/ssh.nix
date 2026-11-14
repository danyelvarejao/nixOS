{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # Private hosts stay out of Git, in ~/.ssh/config.local.
    includes = [ "config.local" ];
    # Cache the key in ssh-agent after the first unlock, so the passphrase is asked once per session.
    settings."*".addKeysToAgent = "yes";
  };

  services.ssh-agent.enable = true;
}
