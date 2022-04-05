{ config, pkgs, ... }:

{
  imports = [ ./felix.nix ];

  # services.localtime.enable = true;

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
    desktopManager = {
      xfce.enable = true;
    };
    xkbOptions = "caps:super";
  };

  # systemd.services.xcape = {
  #   enable = true;
  #   description = "xcape to use CTRL as ESC when pressed alone";
  #   wantedBy = [ "default.target" ];
  #   serviceConfig.Type = "forking";
  #   serviceConfig.Restart = "always";
  #   serviceConfig.RestartSec = 2;
  #   serviceConfig.ExecStart = "${pkgs.xcape}/bin/xcape -e 'Super_L=Escape'";
  # };

  nixpkgs.config.pulseaudio = true;
  
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [
    wget vim git ping
  ];

  fonts = {
    fonts = with pkgs; [
      terminus_font
      # unifont
      fira-code
      # _3270font
      # mno16
      # fixedsys-excelsior
      # dejavu_fonts
      # mononoki
      # cozette
    ];
  };
}
