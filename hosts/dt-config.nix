{ config, pkgs, ... }:

{
  imports = [./dt-hardware.nix];

  services.xserver.videoDrivers = [ 
    # "modesetting" 
    "nvidia" 
  ];

  # boot.blacklistedKernelModules = ["nouveau" "nvidiafb"];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
    # extraModulePackages = [ config.boot.kernelPackages.rtl8xxxu ];
  };

  # boot.kernelPackages = pkgs.linuxPackages_4_9;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [
    config.boot.kernelPackages.nvidia_x11
    # config.boot.kernelPackages.rtl8192eu
    # config.boot.kernelPackages.rtl8822bu
  ];

  # boot.loader.grub.gfxmodeEfi = "1920x1080";
  # boot.loader.grub.gfxpayloadEfi ="";
  # boot.loader.grub.gfxpayloadEfi = "1920x1080";

  networking = {
    hostName = "dt";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      # enp0s20u9.useDHCP = true;
      enp3s0.useDHCP = true;
      # wlp0s20u10.useDHCP = true;
    };
  };

  hardware.opengl.extraPackages = with pkgs; [
    opencl-icd
    ocl-icd
    intel-ocl
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

