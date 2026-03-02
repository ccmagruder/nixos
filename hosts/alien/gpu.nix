{ config, pkgs, ... }: {
  # 1. Enable the NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

  # 2. Required for 2026 (NixOS 25.11+)
  hardware.graphics.enable = true; 

  # 3. Allow unfree software (NVIDIA drivers are proprietary)
  nixpkgs.config.allowUnfree = true;

  hardware.nvidia = {
    # Modesetting is required for most modern setups
    modesetting.enable = true;
    # Decides between open-source or proprietary kernel modules
    open = false; 
    # Installs nvidia-settings and nvidia-smi
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
  nix.settings = {
    trusted-users = [ "root" "remote" ];

    sandbox = "relaxed";

    extra-sandbox-paths = [
      "/dev/nvidia0"
      "/dev/nvidiactl"
      "/dev/nvidia-modeset"
      "/run/opengl-driver=${config.hardware.graphics.package}"
   ];

    extra-system-features = [ "cuda" "cuda-89" ];
  };
}
