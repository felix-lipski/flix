{ config, pkgs, ... }:

{
  imports = [./hard/dt.nix];

  services.xserver.videoDrivers = [ 
    "nvidia" 
  ];
  
  programs.steam.enable = true;

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = [
    config.boot.kernelPackages.nvidia_x11
  ];

  networking = {
    hostName = "dt";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp3s0.useDHCP = true;
    };
  };

  hardware.opengl.extraPackages = with pkgs; [
    opencl-icd
    ocl-icd
    intel-ocl
    vulkan-loader
    vulkan-validation-layers
    vulkan-headers
    mesa
  ];
  hardware.opengl.driSupport.enable = true;

  environment.systemPackages = with pkgs; [
    wineWowPackages.stable wine (wine.override { wineBuild = "wine64"; }) 
    wineWowPackages.staging (winetricks.override { wine = wineWowPackages.staging; })
    lutris
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

