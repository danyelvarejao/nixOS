{ ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    # Private hosts stay out of Git, in ~/.ssh/config.local.
    includes = [ "config.local" ];
  };

  services.ssh-agent.enable = true;
}
