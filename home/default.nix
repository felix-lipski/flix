{ lib, pkgs, config, inputs, unstable, ... }: let
  spacelixVariant = "dark";
  # palette = config.ui.spacelix."${spacelixVariant}".withGrey;
  palette = import ./gruvbox.nix;
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
    extraGroups = [ "wheel" "audio" "docker" ];
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
        ]) ++ (with unstable; [
          godot blender brave mpv spotify
        ]);
        home.file = {
          ".xinitrc".text = "exec xmonad";
          ".xmobarrc".text =
          (utils.interpolateColors (palette // { fontSize = (builtins.toString (fontSizeSmall)); fontFace = font; })
            (builtins.readFile ./resources/xmobarrc.hs)
          );
          "wallpaper.png".source = ''${(import ./wallpaper.nix) {inherit pkgs inputs palette;}}/wallpaper.png'';
          ".config/nvim/colors/xelex.vim".source = resources/xelex.vim;
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
        programs = (import ./programs.nix) palette font fontSize lib pkgs;
      };
    };
  };
}
