{ config, pkgs, ... }:

{
  imports = [./hard/dt.nix];

  services.xserver.videoDrivers = [ "nvidia" ];
  
  programs.steam.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  networking = {
    hostName = "dt";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp3s0.useDHCP = true;
    };
  };

  hardware.opengl.extraPackages = with pkgs; [
    opencl-icd ocl-icd intel-ocl
    vulkan-loader vulkan-validation-layers vulkan-headers
    mesa
  ];
  hardware.opengl.driSupport.enable = true;

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable wine (wine.override { wineBuild = "wine64"; }) 
    wineWowPackages.staging (winetricks.override { wine = wineWowPackages.staging; })
    lutris
  ];

  system.stateVersion = "21.05";
}

