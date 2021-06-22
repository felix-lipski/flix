{ config, pkgs, ... }:

{
  imports = [./felix.nix];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  nixpkgs.config.allowUnfree = true;

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

# virtualisation.docker.enable = true;

  fonts = {
    fonts = with pkgs; [
      terminus_font
      unifont
      fira-code
      _3270font
      mno16
      fixedsys-excelsior
      dejavu_fonts
      mononoki
    ];
  };

  system.stateVersion = "20.09";
}
