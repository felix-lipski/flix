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
          palette = ((import ./spacelix.nix) {inherit lib;}).spacelix-ocean;
          font = "Terminus";
          utils = (import ./utils.nix) {lib=lib;};
        in {
          home.file.".xinitrc".text = ''
${pkgs.xcape}/bin/xcape -e 'Super_L=Escape'
exec xmonad
'';
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
	home.packages = with pkgs; [
	  brave
          lf
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
                bright = palette.light; # // {black = (utils.lightenHex palette.named.black);};
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
