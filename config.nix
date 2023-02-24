{ config, pkgs, inputs, ... }: let
in {
  imports = [ ./home/default.nix ];

  networking.wireless.athUserRegulatoryDomain = true;

  virtualisation.docker.enable = true;
  networking.wireguard.enable = true;
  programs.ssh.startAgent = true;
  
  # networking.extraHosts = ''
# 127.0.0.1 www.frenschan.org
# 127.0.0.1 frenschan.org
# 127.0.0.1 4chan.org
# 127.0.0.1 www.4chan.org
# 127.0.0.1 4channel.org
# 127.0.0.1 boards.4channel.org
# 127.0.0.1 youtube.com
# ::1 youtube.com
# 127.0.0.1 www.youtube.com
# ::1 www.youtube.com
# 127.0.0.1 twitter.com
# ::1 twitter.com
  # '';

  security.pam.services.pass.gnupg.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gtk2";
  };
  
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = "experimental-features = nix-command flakes";
    # binaryCachePublicKeys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    # binaryCaches = [ "https://hydra.iohk.io" ];

    # settings.trusted-public-keys = [ 
    #   "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    # ];
    # # settings.substituters = [ "https://hydra.iohk.io" ];
    # settings.substituters = [ 
    #   "https://cache.nixos.org"
    # ];
    settings = {
      substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
          "https://hydra.iohk.io"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    layout = "pl";
    enable = true;
    displayManager = {
      startx.enable = true;
      defaultSession = "none+xmonad";
    };
    desktopManager.xfce.enable = true;
    windowManager.windowmaker.enable = true;
    xkbOptions = "caps:super";
  };

  services.unclutter-xfixes.enable = true;

  sound.enable = true;
  hardware.opengl.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };


  environment.systemPackages = with pkgs; [
    moreutils
    inetutils pciutils coreutils udev usbutils
    file ripgrep lf vimv wget unzip zip p7zip
    git vim tmux gnumake gcc cmake
  ];

  fonts.fonts = with pkgs; [ terminus_font terminus_font_ttf fira-code uni-vga ];
}
