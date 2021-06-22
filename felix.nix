{ lib, pkgs, config, inputs, ... }:
let
  paletteVariant = "black";
  palette = config.ui.spacelix."${paletteVariant}";
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
        home.file.".xmobarrc".text =
          (utils.interpolateColors palette.withGrey
            (builtins.readFile ./resources/xmobarrc.hs)
          );
        home.file."wallpaper.png".source = resources/wallpaper.png;
        xsession = {
          enable = true;
          windowManager.xmonad = {
          enable = true;
	      enableContribAndExtras = true;
            config = pkgs.writeText "xmonad.hs" 
              (utils.interpolateColors palette.withGrey
                (builtins.readFile ./resources/xmonad.hs)
              );
	      };
	    };
        services.lorri.enable = true;
        services.picom = {
          enable = true;
          extraOptions = ''
            corner-radius = 10;
          '';
        };
	    home.packages = with pkgs; [
          haskellPackages.xmobar nitrogen
	      brave qutebrowser zathura mpv
          gnumake gcc cmake direnv unzip
          tmux ripgrep coreutils
          dmenu lf sxiv vimv
          xcape
          yarn
          rustc cargo
          cabal2nix cabal-install
          emacsGcc
          (agda.withPackages [ agdaPackages.standard-library ])
	    ];
        programs = {
          alacritty = {
            enable = true;
            settings = {
              shell.program = "zsh";
              font = {
              # size = 12;
                size = 9;
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
	          ls      = "ls --color";
              l       = "ls -la";
              v       = "nvim";
	          m       = "make";
              e       = "make edit";
	          c       = "cd";
	          g       = "git";
              x       = "exit";
              nsh     = "nix develop --command zsh";
              nunfree = "export NIXPKGS_ALLOW_UNFREE=1";
              xc      = "xcape -e 'Super_L=Escape'";
              gcroots = "nix-store --gc --print-roots | grep home/"; 
            };
            localVariables = {
              PROMPT = "%F{blue}%n%f %F{green}%~%f ";
              EDITOR = "nvim";
              F = "https://github.com/felix-lipski/";
            };
            initExtra = lib.fileContents ./resources/zshrc;
          };
          neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [ 
              # general
              gruvbox 
	          nvim-treesitter
              vim-commentary
	          vim-css-color
              goyo-vim
              # misc langs
              vim-glsl
              # functional langs
	          vim-nix
              vim-ocaml
              agda-vim
              conjure
              aniseed
              # soydev langs
              coc-nvim
            # coc-tsserver
            # coc-eslint
            # coc-tslint
            # coc-snippets
            # coc-prettier
            ];
            extraConfig = lib.fileContents ./resources/init.vim;
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
