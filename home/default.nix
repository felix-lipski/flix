{ lib, pkgs, config, inputs, ... }:
let
  spacelixVariant = "dark";
  # palette = config.ui.spacelix."${spacelixVariant}".withGrey;
  palette = import ./gruvbox.nix;

  fontConfig = rec {
    font = "Terminus";
    fontSize = 16;
    fontSizeSmall = fontSize - 4;
  };

  utils = (import ./utils.nix) { inherit lib; };
  pkgs-unstable = import inputs.unstable {
    config = { allowUnfree = true; };
    system = "x86_64-linux";
  };
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
          haskellPackages.xmobar nitrogen scrot neofetch
          gnumake gcc cmake unzip ffmpeg
          tmux ripgrep coreutils zip file xcape
          dmenu lf sxiv vimv appimage-run
          glxinfo opencl-info clinfo pciutils

          cabal2nix cabal-install
          haskellPackages.haskell-language-server ghcid ghc
          yarn nodejs python3
          
          (agda.withPackages [ agdaPackages.standard-library ])
          libreoffice krita
        ]) ++ (with pkgs-unstable; [
          godot blender
          brave mpv spotify
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
              (utils.interpolateColors (palette // { fontSize = (builtins.toString fontSizeSmall); fontFace = font; })
                (builtins.readFile ./resources/xmonad.hs)
              );
	      };
	    };
        programs = {
          direnv.enable = true;
          direnv.stdlib = ''
            use_flake() {
              watch_file flake.nix
              watch_file flake.lock
              eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
            }
          '';
          neovim = {
            enable = true;
            plugins = with pkgs.vimPlugins; [ 
	          nvim-treesitter vim-commentary vim-css-color goyo-vim vim-glsl vim-closetag coc-nvim coc-prettier
              vim-nix vim-ocaml haskell-vim agda-vim conjure aniseed ats-vim latex-box futhark-vim
              # (pkgs.vimUtils.buildVimPlugin { name = "futhark-vim"; src = inputs.futhark-vim; })
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
          alacritty = (import ./alacritty.nix) palette font;
          zsh = (import ./zsh.nix) palette lib;
          qutebrowser = (import ./qute.nix) palette font fontSize;
          vscode.enable = true;
        };
      };
    };
  };
}
