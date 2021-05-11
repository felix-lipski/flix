{ config, pkgs, ... }:

{
  imports = [./felix.nix];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  services.xserver = {
    enable = true;
    displayManager = {
      startx.enable = true;
      defaultSession = "none+xmonad";
    };
    xkbOptions = "caps:super";
  };
  
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    wget vim git ping
  ];

  fonts.fonts = with pkgs; [
    terminus_font
    fira-code
    _3270font
    mno16
  ];

  system.stateVersion = "20.09";
}
