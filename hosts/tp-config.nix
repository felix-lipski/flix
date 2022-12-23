{ config, pkgs, ... }:

{
  imports = [./tp-hardware.nix];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  # programs.steam.enable = true;

  networking = {
    hostName = "tp";
    networkmanager.enable = true;
    useDHCP = false;
    interfaces = {
      enp0s25.useDHCP = true;
      wlp3s0.useDHCP = true;
      wwp0s29u1u4.useDHCP = true;
    };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    # steam
  ];
}
