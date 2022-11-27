{ lib, pkgs, config, inputs, ... }: let
  spacelixVariant = "dark";
  gruvbox   = import ./palettes/gruvbox.nix;
  solarized = import ./palettes/solarized.nix;
  spacelix  = import ./palettes/spacelix.nix;
  # palette = solarized // (with spacelix; {inherit black white grey;});
  palette = spacelix;
  theme = (import ./theme/default.nix) {inherit pkgs palette;};
  fontConfig = rec {
    font = "Terminus";
    fontSize = 16;
    fontSizeSmall = 12;
  };
  utils = (import ./utils.nix) { inherit lib; };
in with palette; with fontConfig; {
  console.colors = map (lib.strings.removePrefix "#") ([
    black red green yellow blue magenta cyan white
    grey  red green yellow blue magenta cyan white
  ]);
  users.users.felix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" "networkmanager" "network" "pipewire" ];
  };
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      felix = {
        home.packages = (with pkgs; [
          haskellPackages.xmobar nitrogen scrot ffmpeg xcape dmenu sxiv 
          glxinfo opencl-info clinfo
          binutils

          cabal2nix cabal-install haskellPackages.haskell-language-server ghcid
          (pkgs.haskellPackages.ghcWithPackages (pkgs: with pkgs; [ xmonad xmonad-contrib xmonad-extras ]))

          appimage-run yarn nodejs python3
          (agda.withPackages [ agdaPackages.standard-library ])
          libreoffice gimp
          spotify-cli-linux pass 
          godot blender brave mpv firefox 
          signal-desktop slack

          wineWowPackages.stagingFull winetricks lutris

          pipes cbonsai htop zenith neofetch pfetch
          (writeScriptBin "ech" ''
            echo $1
            echo $1 >> /tmp/ech.log
          '')
          mutt-wizard neomutt
        ]);
        home.file = {
          ".xinitrc".text = "exec xmonad";
          ".xmobarrc".text =
          (utils.interpolateColors (palette // { fontSize = (builtins.toString (fontSizeSmall)); fontFace = font; })
            (builtins.readFile ./resources/xmobarrc.hs)
          );
          "help.md".source = resources/help.md;
          ".config/nvim/coc-settings.json".text = ''{"suggest.noselect": false}'';
          ".agda".source = (import resources/agda-dir.nix) { inherit pkgs; };
          ".config/nvim/colors/xelex.vim".source = resources/xelex.vim;
          "wallpaper.png".source = ''${theme}/wallpaper.png'';
          ".doom.d/themes/doom-spacelix-theme.el".source = ''${theme}/doom.el'';
          ".vscode/extensions/felix-lipski.spacelix-1.0.0/theme.json".source = ''${theme}/vsc.json'';
        };
        home.sessionPath = [
          "$HOME/.emacs.d/bin" 
          "$HOME/code/shen/shen-cl-v3.0.3-sources/bin/sbcl"
        ];
        home.keyboard.layout = "pl";
        xsession = {
          enable = true;
          windowManager.xmonad = {
            enable = true;
	        enableContribAndExtras = true;
            config = pkgs.writeText "xmonad.hs" 
              (utils.interpolateColors (palette // { fontSize = (builtins.toString fontSize); fontFace = font; })
                (builtins.readFile ./resources/xmonad.hs)
              );
	      };
	    };
        systemd.user.sessionVariables.DISPLAY = ":0";
        systemd.user.services.xcape = {
          Unit = {
            Description= "Xcape Daemon";
            After="graphical.target";
          };
          Service = {
            Type="forking";
            ExecStart = "${pkgs.xcape}/bin/xcape -e 'Super_L=Escape'";
            Restart = "always";
            RestartSec = 5;
          };
          Install = {
            WantedBy=["default.target"];
          };
        };
        services.emacs.enable = true;
        programs = (import ./programs.nix) utils palette font fontSize lib pkgs config;
      };
    };
  };
}
