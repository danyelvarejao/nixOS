# NVIDIA RTX 4070 Ti Super (Ada) on Wayland/Hyprland, with the open kernel module.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  nvidia = config.hardware.nvidia.package;

  # Workaround for the stutter after the desktop sits idle: the GPU drops to P8 and
  # takes a moment to clock back up. A "min,max" pair in MHz (max = `nvidia-smi -q -d
  # SUPPORTED_CLOCKS`), or null to let the driver manage clocks freely.
  # Diagnose while it happens: `nvidia-smi dmon -s pc` (clocks/p-state per second).
  lockGpuClocks = "1000,3150";
in
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    nvidiaSettings = false;
  };

  # VA-API on top of NVDEC, for hardware video decoding in browsers and mpv.
  hardware.graphics.extraPackages = [ pkgs.nvidia-vaapi-driver ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  systemd.services.nvidia-lock-gpu-clocks = lib.mkIf (lockGpuClocks != null) {
    description = "Lock the NVIDIA GPU clock range";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # Persistence mode keeps the driver loaded, so the clock lock is not dropped.
      ExecStart = [
        "${nvidia.bin}/bin/nvidia-smi --persistence-mode=1"
        "${nvidia.bin}/bin/nvidia-smi --lock-gpu-clocks=${lockGpuClocks}"
      ];
      ExecStop = "${nvidia.bin}/bin/nvidia-smi --reset-gpu-clocks";
    };
  };
}
