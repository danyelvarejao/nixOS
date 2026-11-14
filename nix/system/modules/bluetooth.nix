# Opt-in: import from hosts that have a Bluetooth adapter (e.g. a notebook).
{ ... }:
{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;
}
