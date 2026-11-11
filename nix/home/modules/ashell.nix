{ lib, ... }:
{
  stylix.targets.ashell.enable = true;

  programs.ashell = {
    enable = true;
    systemd.enable = true;
    settings = {
      region = "pt-BR"; # Dates only; the rest of the bar stays in English.
      position = "Bottom";
      appearance = {
        scale_factor = 1.3;
        opacity = lib.mkForce 0.1;
        menu = {
          opacity = lib.mkForce 0.4;
          backdrop = 0.2;
        };
      };
      notifications = {
        format = "%d/%m %H:%M";
        show_timestamps = true;
        show_bodies = false;
        grouped = true;
        toast = true;
        position = "top_right";
        toast_timeout = 4000;
        toast_limit = 5;
        toast_max_height = 150;
        blocklist = [ ];
      };
      settings = {
        remove_airplane_btn = true;
        audio_sinks_more_cmd = "pavucontrol -t 3";
        audio_sources_more_cmd = "pavucontrol -t 4";
        indicators = [
          "PowerProfile"
          "Audio"
          "Bluetooth"
          "Network"
          "Battery"
        ];
      };
      system_info.indicators = [
        "Cpu"
        "Memory"
        "Temperature"
        { Disk = "/"; }
      ];
      tempo = {
        clock_format = "%a %d/%m/%Y %H:%M:%S %Z";
        timezones = [
          "America/Recife"
          "UTC"
        ];
      };
      modules = {
        left = [
          "Workspaces"
          "MediaPlayer"
        ];
        center = [
          "WindowTitle"
        ];
        right = [
          "SystemInfo"
          [
            "Tempo"
            "Tray"
            "Privacy"
            "Settings"
            "Notifications"
          ]
        ];
      };
    };
  };
}
