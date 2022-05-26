{ config, pkgs, ... }: {
  imports = [ ./home/default.nix ];

  security.pam.services.pass.gnupg.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };
  
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    binaryCaches = [ "https://hydra.iohk.io" ];
  };

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    layout = "pl";
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

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    inetutils pciutils coreutils udev binutils
    file ripgrep lf vimv wget unzip zip p7zip
    git vim tmux gnumake gcc cmake
    # gnupg pinentry
  ];

  fonts.fonts = with pkgs; [ terminus_font fira-code ];
}
