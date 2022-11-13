{ config, pkgs, inputs, ... }: let
  # pkgs-old = inputs.nixpkgs.legacyPackages.x86_64-linux;
  pinnedKernelPackages = pkgs.old.linuxPackages_latest;
in {
  imports = [./hard/dt.nix];

  nixpkgs.config.packageOverrides = pkgs: {
    linuxPackages_latest = pinnedKernelPackages;
    # nvidia_x11 = inputs.nixpkgs.nvidia_x11;
    nvidia_x11 = pkgs.old.nvidia_x11;
    nvidia_x11_legacy470 = pkgs.old.nvidia_x11_legacy470;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.videoDrivers = [ "legacy_470" ];
  hardware.nvidia.package = config.boot.kernelPackages.nvidia_x11_legacy470;
  # hardware.nvidia.package = pkgs-old.linuxKernel.packages.linux_5_17.nvidia_x11_legacy470;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pinnedKernelPackages;
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  
  programs.steam.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
  };

  networking = {
    hostName = "dt";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp3s0.useDHCP = true;
    };
  };

  hardware.opengl.extraPackages = with pkgs; [
    # opencl-icd ocl-icd intel-ocl
    ocl-icd intel-ocl
    vulkan-loader vulkan-validation-layers vulkan-headers
    mesa
  ];
  hardware.opengl.driSupport.enable = true;

  environment.systemPackages = with pkgs; [
    # # wine
    # # wineWowPackages.stable 
    # # wine-staging
    # wineWowPackages.stagingFull
    # # wineWowPackages.stable wine (wine.override { wineBuild = "wine64"; }) 
    # # # wineWowPackages.staging (winetricks.override { wine = wineWowPackages.staging; })
    # # # wineWowPackages.staging winetricks
    # winetricks
    # lutris
  ];

  system.stateVersion = "21.05";
}

