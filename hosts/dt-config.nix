{ config, pkgs, ... }:

{
  imports = [./dt-hardware.nix];

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
  ];

  environment.systemPackages = with pkgs; [
    # support both 32- and 64-bit applications
    wineWowPackages.stable
    # support 32-bit only
    wine
    # support 64-bit only
    (wine.override { wineBuild = "wine64"; })
    # wine-staging (version with experimental features)
    wineWowPackages.staging
    # winetricks and other programs depending on wine need to use the same wine version
    (winetricks.override { wine = wineWowPackages.staging; })

    # wine-mono

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

