{ config, pkgs, inputs, ... }: let
# pinnedKernelPackages = inputs.nixpkgs.linuxPackages_latest;
# pinnedKernelPackages = inputs.nixpkgs.legacyPackages.x86_64-linux.linuxPackages_latest;
  # pinnedKernelPackages = pkgs.old.linuxPackages_latest;
in {
  imports = [ ./home/default.nix ];

  networking.wireless.athUserRegulatoryDomain = true;
  # networking.wireless.enable = false;

  virtualisation.docker.enable = true;
  networking.wireguard.enable = true;
  programs.ssh.startAgent = true;
  
  # networking.extraHosts = ''
  # '';
  # 127.0.0.1 youtube.com
  # ::1 youtube.com
  # 127.0.0.1 www.youtube.com
  # ::1 www.youtube.com
  # 127.0.0.1 4chan.org
  # 127.0.0.1 www.4chan.org
  # 127.0.0.1 4channel.org
  # 127.0.0.1 boards.4channel.org
  # 127.0.0.1 reddit.com
  # 127.0.0.1 www.reddit.com
  # 127.0.0.1 www.frenschan.org
  # 127.0.0.1 frenschan.org

  # services.resolved.enable = true;
  # services.resolved.dnssec = "false";

  # services.resolved.domains = [ "~dev.manca.ro" ];
  # networking.nameservers = [ "10.244.129.252" ];

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
    settings.trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    settings.substituters = [ "https://hydra.iohk.io" ];
  };

  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.packageOverrides = pkgs: {
  #   linuxPackages_latest = pinnedKernelPackages;
  #   # nvidia_x11 = inputs.nixpkgs.nvidia_x11;
  #   nvidia_x11 = pkgs.old.nvidia_x11;
  # };
  # boot.kernel


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
  # hardware.pulseaudio.enable = true;
  hardware.opengl.enable = true;
  # nixpkgs.config.pulseaudio = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };


  environment.systemPackages = with pkgs; [
    inetutils pciutils coreutils udev usbutils
 # binutils
    file ripgrep lf vimv wget unzip zip p7zip
    git vim tmux gnumake gcc cmake
    # gnupg pinentry
  ];

  fonts.fonts = with pkgs; [ terminus_font terminus_font_ttf fira-code uni-vga ];
}
