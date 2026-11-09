{ ... }:
{
  programs.hyprlock.enable = true;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        after_sleep_cmd = ''hyprctl dispatch 'hl.dsp.dpms({ action = "on" })' '';
        lock_cmd = "hyprlock";
      };
      listener = [
        {
          timeout = 1200;
          on-timeout = ''hyprctl dispatch 'hl.dsp.dpms({ action = "off" })' '';
          on-resume = ''hyprctl dispatch 'hl.dsp.dpms({ action = "on" })' '';
        }
      ];
    };
  };
}
