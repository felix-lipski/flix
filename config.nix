{ config, pkgs, ... }:

{
  imports = [ ./felix.nix ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    binaryCachePublicKeys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];
    binaryCaches = [
      "https://hydra.iohk.io"
    ];
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

  nixpkgs.config.pulseaudio = true;
  
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    wget vim git ping
  ];

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
      cozette
    ];
  };

  # networking.extraHosts = ''
  #   0.0.0.0 youtube.com
  #   0.0.0.0 m.youtube.com
  #   0.0.0.0 www.youtube.com
  # '';

  system.stateVersion = "20.09";
}
