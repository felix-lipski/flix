{ config, pkgs, ... }:

{
  networking.hostName = "vm"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.


# imports =
#   [ 
#   # ./hardware-configuration.nix
#     ./felix.nix
#   ];

# boot.loader.grub.enable = true;
# boot.loader.grub.version = 2;
# boot.loader.grub.device = "/dev/sda";
# networking.useDHCP = false;
# networking.interfaces.ens33.useDHCP = true;

# nix = {
#   package = pkgs.nixUnstable;
#   extraOptions = ''
#     experimental-features = nix-command flakes
#   '';
# };

# services.xserver = {
#   enable = true;
#   displayManager = {
#     startx.enable = true;
#     defaultSession = "none+xmonad";
#   };
#   xkbOptions = "caps:super";
# };
# 
# sound.enable = true;
# hardware.pulseaudio.enable = true;

# environment.systemPackages = with pkgs; [
#   wget
#   vim
#   git 
#   dmenu
#   gnumake
#   gcc
# ];

# nixpkgs.overlays = [ ];

# fonts.fonts = with pkgs; [
#   terminus_font
#   fira-code
#   _3270font
#   mno16
# ];

# system.stateVersion = "20.09";












  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.

# networking.hostName = "vm"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;




  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

}

