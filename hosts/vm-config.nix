{ config, pkgs, ... }:

{
  imports = [./vm-hardware.nix];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };

  networking = {
    hostName = "vm";
    useDHCP = false;
    interfaces.ens33.useDHCP = true;
  };
}
