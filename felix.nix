{ lib, pkgs, config, ... }:
{
  users.users.felix = {
    password = "n";
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      felix = 
        let
        # palette = ((import /home/felix/code/spacelix/spacelix.nix) {inherit lib;}).deep;
          palette = config.ui.spacelix.deep;
          font = "Terminus";
          utils = (import ./utils.nix) {lib=lib;};
        in {
        home.file.".xinitrc".text = "exec xmonad";
        xsession = {
	  enable = true;
	  windowManager.xmonad = {
	    enable = true;
	    enableContribAndExtras = true;
            config = pkgs.writeText "xmonad.hs" 
              (utils.interpolateColors palette.dark
                (builtins.readFile ./xmonad.hs)
              );
	  };
	};
        services.lorri.enable = true;
	home.packages = with pkgs; [
          direnv
          xcape
	  brave
          lf
          yarn
          # haskell
          cabal2nix
          cabal-install
        # haskellPackages.Agda
	];
        programs = {
          alacritty = {
            enable = true;
            settings = {
              shell.program = "zsh";
              font = {
                normal.family = font;
                bold.family   = font;
                italic.family = font;
              };
              cursor.style = "Beam";
              colors = {
                primary = with palette.dark; {
                  background = black;
                  foreground = white;
                };
                normal = palette.dark;
                bright = palette.light;
                dim    = palette.dark;
              };
            };
          };
          zsh = {
            enable = true;
            dotDir = ".config/zsh";
            shellAliases = {
	      ls  = "ls --color";
              l   = "ls -la";
              v   = "nvim";
	      m   = "make";
	      c   = "cd";
	      g   = "git";
              xc  = "xcape -e 'Super_L=Escape'";
            };
            localVariables = {
              PROMPT = "%F{blue}%n%f %F{green}%~%f ";
              EDITOR = "nvim";
            };
            initExtra = lib.fileContents ./zshrc;
          };
          neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [ 
              gruvbox 
	      nvim-treesitter
	      vim-css-color
	      vim-nix
              goyo-vim
              agda-vim
            ];
            extraConfig = lib.fileContents ./init.vim;
          };
          git = {
            enable = true;
            userEmail = "felix.lipski7@gmail.com";
            userName = "felix-lipski";
          };
        };
      };
    };
  };
}
