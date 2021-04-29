{ lib, pkgs, ... }:
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
          palette = (import ./colors.nix);
        in {
        home.file.".xinitrc".text = "exec xmonad";
        xsession = {
	  enable = true;
	  windowManager.xmonad = {
	    enable = true;
	    enableContribAndExtras = true;
            config = pkgs.writeText "xmonad.hs" 
              (palette.interpolateColors
                (builtins.readFile ./xmonad.hs)
              );
	  };
	};
	home.packages = with pkgs; [
	  brave
	];
        programs = {
          alacritty = {
            enable = true;
            settings = {
              shell.program = "zsh";
              font = {
                normal.family = "Terminus";
                bold.family = "Terminus";
                italic.family = "Terminus";
              };
              cursor.style = "Beam";
              colors = {
                primary = with palette.named; {
                  background = black;
                  foreground = white;
                };
                normal = palette.named;
                bright = palette.named;
                dim    = palette.named;
              };
            };
          };
          zsh = {
            enable = true;
            dotDir = ".config/zsh";
            shellAliases = {
	      ls = "ls --color";
              l = "ls -la";
              v = "nvim";
	      m = "make";
	      c = "cd";
	      g = "git";
            };
            localVariables = {
              PROMPT = "%F{blue}%n%f %F{green}%~%f ";
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
