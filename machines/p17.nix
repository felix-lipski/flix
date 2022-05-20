# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
  imports = [ ./hard/p17.nix ];
  virtualisation.docker.enable = true;
  environment.systemPackages = with pkgs; [ docker-compose ];

  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.enable = true;
  # hardware.opengl.extraPackages = with pkgs; [
  #   opencl-icd
  #   opencl-headers
  #   ocl-icd
  #   # unstable_pkgs.intel-ocl
  #   vulkan-loader
  #   vulkan-validation-layers
  #   vulkan-headers
  #   mesa
  # ];

  # hardware.nvidia.modesetting.enable = true;
  # services.xserver.videoDrivers = [ 
  #   "intel"
  #   "nvidia"
  # ];

  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.legacy_390;

  # boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.extraModulePackages = [
  #   config.boot.kernelPackages.nvidia_x11
  # ];
  # boot.blacklistedKernelModules = ["nouveau"];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "p17";
    networkmanager.enable = true;
    extraHosts = ''
      127.0.0.1	oauth-server
      127.0.0.1	notification-server
    '';
  };

  # services.xserver.libinput.mouse.accelSpeed = "-0.5";
  services.xserver.libinput.mouse.accelProfile = "flat";
  # hardware.trackpoint.sensitivity = 16;
  # hardware.trackpoint.speed = 10;

  # hardware.opengl.extraPackages = with pkgs; [
  #   opencl-icd
  #   opencl-headers
  #   ocl-icd
  #   # unstable_pkgs.intel-ocl
  #   vulkan-loader
  #   vulkan-validation-layers
  #   vulkan-headers
  #   mesa
  # ];

  # hardware.opengl.enable = true;
  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

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
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };


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
  system.stateVersion = "21.11"; # Did you read the comment?
}
