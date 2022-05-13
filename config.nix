{ config, pkgs, ... }: {
  imports = [ ./home/default.nix ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    binaryCaches = [ "https://hydra.iohk.io" ];
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

  nixpkgs.config.pulseaudio = true;
  
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;

  environment.systemPackages = with pkgs; [ wget vim git ping ];

  fonts.fonts = with pkgs; [ terminus_font fira-code ];
}
