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
      felix = {
        services.xcape = {
	  enable = true;
	  mapExpression = {
	    Shift_L = "Escape";
	  };
	};
        home.file.".xinitrc".text = "exec xmonad";
        xsession = {
	  enable = true;
	  windowManager.xmonad = {
	    enable = true;
	    enableContribAndExtras = true;
	    config = ./dotfiles/xmonad.hs;
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
              colors =
                let
                  palette = (import ./palette.nix).palette;
                in {
                primary = with palette; {
                  background = black;
                  foreground = white;
                };
                normal = palette;
                bright = palette;
                dim    = palette;
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
              PROMPT = "%F{blue}%n%f %F{yellow}%~%f ";
            };
            initExtra = "${ lib.fileContents ./dotfiles/zshrc }";
          };
          neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [ 
              gruvbox 
	      nvim-treesitter
	      vim-css-color
	      vim-nix
            ];
	    extraConfig = ''
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "nix" },
  highlight = {
    enable = { "nix" },
    disable = {},
  },
}
EOF
	    '';
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
