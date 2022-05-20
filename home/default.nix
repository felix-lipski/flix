{ lib, pkgs, config, inputs, unstable, ... }: let
  spacelixVariant = "slate";
  spacelix = config.ui.spacelix."${spacelixVariant}".withGrey // {magenta = "#fe8019";};
  gruvbox = import ./gruvbox.nix;
  solarized = import ./solarized.nix;
  palette = solarized // (with spacelix; {inherit black white grey;});
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
    password = "n";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" "networkmanager" "network" ];
  };
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      felix = {
        home.packages = (with pkgs; [
          haskellPackages.xmobar nitrogen scrot neofetch ffmpeg xcape dmenu sxiv 
          glxinfo opencl-info clinfo

          cabal2nix cabal-install haskellPackages.haskell-language-server ghcid
          (pkgs.haskellPackages.ghcWithPackages (pkgs: with pkgs; [ xmonad xmonad-contrib xmonad-extras ]))

          appimage-run yarn nodejs python3
          (agda.withPackages [ agdaPackages.standard-library ])
          libreoffice krita gimp
          spotify-cli-linux
          pass 
        ]) ++ (with unstable; [
          godot blender brave mpv
          firefox 
        ]);
        home.file = {
          ".xinitrc".text = "exec xmonad";
          ".xmobarrc".text =
          (utils.interpolateColors (palette // { fontSize = (builtins.toString (fontSizeSmall)); fontFace = font; })
            (builtins.readFile ./resources/xmobarrc.hs)
          );
          "wallpaper.png".source = ''${(import ./wallpaper.nix) {inherit pkgs inputs palette;}}/wallpaper.png'';
          ".config/nvim/colors/xelex.vim".source = resources/xelex.vim;
          "help.md".source = resources/help.md;
          ".config/nvim/coc-settings.json".text = ''{"suggest.noselect": false}'';
          ".doom.d/themes/doom-spacelix-theme.el".text = 
            (utils.interpolateColors palette
              (builtins.readFile ./resources/doom-spacelix-theme.el)
            );
          ".agda".source = (import resources/agda-dir.nix) { inherit pkgs; };
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
        services.spotifyd = {
          enable = true;
          settings.global = {
            username = "217mgssuzohnkwxlhrh3vvu6q";
            password_cmd = "${pkgs.pass}/bin/pass spotify";
            initial_volume = "70";
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
            ExecStart = "${pkgs.xcape}/bin/xcape -f -e 'Super_L=Escape'";
            Restart = "always";
            RestartSec = 5;
          };
          Install = {
            WantedBy=["default.target"];
          };
        };
        services.emacs.enable = true;
        programs = (import ./programs.nix) palette font fontSize lib pkgs;
      };
    };
  };
}
