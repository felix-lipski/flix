{ lib, pkgs, config, inputs, ... }:
let
  spacelixVariant = "sea";
  palette = config.ui.spacelix."${spacelixVariant}".withGrey;
  # palette = import ./gruvbox.nix;
  font = "Fira Code";
  # font = "terminus";
  fontSize = 16;
  utils = (import ./utils.nix) {lib=lib;};
  futhark-vim = pkgs.vimUtils.buildVimPlugin {
    name = "futhark-vim";
    src = inputs.futhark-vim;
  };
  wallpaper = (import ./wallpaper.nix) {inherit pkgs inputs palette;};

  pkgs-unstable = import inputs.unstable {
    config = { allowUnfree = true; };
    system = "x86_64-linux";
  };
in
with palette; {
  console.colors = map (lib.strings.removePrefix "#") ([
    black red green yellow blue magenta cyan white
    grey red green yellow blue magenta cyan white
  ]);
  users.users.felix = {
    password = "n";
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
  };
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = {
      felix = {
	    home.packages = (with pkgs; [
          haskellPackages.xmobar nitrogen scrot neofetch
          gnumake gcc cmake direnv unzip ffmpeg
          tmux ripgrep coreutils zip file xcape
          dmenu lf sxiv vimv appimage-run
          inputs.nix-boiler.defaultPackage."x86_64-linux"

          cabal2nix cabal-install
          haskellPackages.haskell-language-server ghcid
          yarn nodejs
          python3
          slack
          metals
          racket
          haskellPackages.shentong
          lispPackages.quicklisp asdf sbcl gcl clisp
          
          (agda.withPackages [ agdaPackages.standard-library ])
          libreoffice
          pcsx2 
        ] ++ (with pkgs.ocamlPackages; [
          merlin utop ocp-indent dune_2 ocamlformat
        ])) ++ (with pkgs-unstable; [
          godot blender krita
          brave mpv spotify
        ]);
        home.file = {
          ".xinitrc".text = "exec xmonad";
          ".xmobarrc".text =
          (utils.interpolateColors (palette // { fontSize = (builtins.toString (fontSize - 4)); fontFace = font; })
            (builtins.readFile ./resources/xmobarrc.hs)
          );
          "wallpaper.png".source = ''${wallpaper}/wallpaper.png'';
          ".config/nvim/colors/xelex.vim".source = resources/xelex.vim;
          ".config/nvim/coc-settings.json".text = ''{"suggest.noselect": false}'';
          ".doom.d/themes/doom-spacelix-theme.el".text = 
            (utils.interpolateColors palette
              (builtins.readFile ./resources/doom-spacelix-theme.el)
            );
          ".agda".source = (import resources/agda-dir.nix) { inherit pkgs; };
        };
        home.sessionPath = [ "$HOME/.emacs.d/bin" ];
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
        services.lorri.enable = true;
        services.picom = {
          enable = true;
          activeOpacity = "0.8";
          inactiveOpacity = "0.8";
          shadow = true;
          extraOptions = ''
            corner-radius = 10;
          '';
        };
        programs = {
          alacritty = {
            enable = true;
            settings = {
              shell.program = "zsh";
              font = {
                # size = 12;
                # size = 9;
                size = fontSize - 4;
                normal.family = font;
                bold.family   = font;
                italic.family = font;
              };
              cursor.style = "Beam";
              colors = rec {
                primary = {
                  background = black;
                  foreground = white;
                };
                normal = { inherit black red green yellow blue magenta cyan white; };
                dim    = normal;
                bright = normal // { black = grey; };
              };
              window.padding = {
                x = 4;
                y = 4;
              };
            };
          };
          zsh = {
            enable = true;
            dotDir = ".config/zsh";
            shellAliases = {
	          ls       = "ls --color";
              l        = "ls -la";
              v        = "nvim";
	          m        = "make";
	          c        = "cd";
	          g        = "git";
              x        = "exit";
              z        = "zathura";
              s        = "sxiv";
	          pgl      = "git log --pretty=oneline";
              nsh      = "nix develop --command zsh";
              nunfree  = "export NIXPKGS_ALLOW_UNFREE=1";
              xc       = "xcape -e 'Super_L=Escape'";
              gcroots  = "nix-store --gc --print-roots | grep home/"; 
              forkterm = "alacritty & disown";
              ssha     = "eval `ssh-agent`; ssh-add";
            };
            localVariables = {
              PROMPT = "%B%F{blue}%n%f %F{green}%~%f%b ";
              EDITOR = "nvim";
              F = "https://github.com/felix-lipski/";
            };
            initExtra = lib.fileContents ./resources/zshrc;
          };
          neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [ 
	          nvim-treesitter vim-commentary vim-css-color goyo-vim vim-glsl vim-closetag coc-nvim coc-prettier

	          vim-nix vim-ocaml futhark-vim haskell-vim agda-vim conjure aniseed ats-vim
            ];
            extraConfig = lib.fileContents ./resources/init.vim;
          };
          git = {
            enable = true;
            lfs.enable = true;
            extraConfig = ''
              [user]
                email = "felix.lipski7@gmail.com";
                name = "felix-lipski";
              [includeIf "gitdir:~/code/sara/"]
                path = ~/.gitconfig-sara
              [includeIf "gitdir:~/code/work/"]
                path = ~/.gitconfig-work
              '';
          };
          zathura = {
            enable = true;
            options = { 
              default-bg = black; 
              default-fg = white; 
            };
            extraConfig = ''
              set recolor-lightcolor \${palette.black}
              set recolor-darkcolor \${palette.white}
              set recolor
            '';
          };
          qutebrowser = (import ./qute.nix) palette font fontSize;
          vscode.enable = true;
        };
      };
    };
  };
}
