{ lib, pkgs, config, ... }:
let
  palette = config.ui.spacelix.abyss;
  font = "Terminus";
  utils = (import ./utils.nix) {lib=lib;};
in
{
  console.colors = map (lib.strings.removePrefix "#") (with palette.withGrey; [
    black red green yellow blue magenta cyan white
    grey red green yellow blue magenta cyan white
  ]);
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
        home.file.".xinitrc".text = "exec xmonad";
        xsession = {
	  enable = true;
	  windowManager.xmonad = {
	    enable = true;
	    enableContribAndExtras = true;
            config = pkgs.writeText "xmonad.hs" 
              (utils.interpolateColors palette.withGrey
                (builtins.readFile ./dotfiles/xmonad.hs)
              );
	  };
	};
        services.lorri.enable = true;
	home.packages = with pkgs; [
	  brave qutebrowser zathura
          gnumake gcc direnv
          dmenu lf
          xcape
          yarn
          cabal2nix cabal-install
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
              F = "https://github.com/felix-lipski/";
            };
            initExtra = lib.fileContents ./dotfiles/zshrc;
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
            extraConfig = lib.fileContents ./dotfiles/init.vim;
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
