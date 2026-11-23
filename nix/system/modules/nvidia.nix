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

  # The core lock alone does not pin the p-state: VRAM still reclocks (10501 down to 5001/810/405 MHz)
  # and every memory retrain stalls scanout for a moment (felt as a hitch while scrolling).
  # A floor keeps it out of P5/P8. "10501,10501" pins P0 and removes it fully, at ~+40 W idle.
  # Supported steps: `nvidia-smi -q -d SUPPORTED_CLOCKS`. Null leaves memory clocks free.
  lockMemClocks = "5001,10501";
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

  systemd.services.nvidia-lock-gpu-clocks =
    lib.mkIf (lockGpuClocks != null || lockMemClocks != null)
      {
        description = "Lock the NVIDIA GPU and memory clock ranges";
        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-modules-load.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          # Persistence mode keeps the driver loaded, so the clock locks are not dropped.
          ExecStart = [
            "${nvidia.bin}/bin/nvidia-smi --persistence-mode=1"
          ]
          ++ lib.optional (
            lockGpuClocks != null
          ) "${nvidia.bin}/bin/nvidia-smi --lock-gpu-clocks=${lockGpuClocks}"
          ++ lib.optional (
            lockMemClocks != null
          ) "${nvidia.bin}/bin/nvidia-smi --lock-memory-clocks=${lockMemClocks}";
          ExecStop = [
            "${nvidia.bin}/bin/nvidia-smi --reset-gpu-clocks"
            "${nvidia.bin}/bin/nvidia-smi --reset-memory-clocks"
          ];
        };
      };
}
