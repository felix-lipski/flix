{ lib, pkgs, config, inputs, ... }:
let
  paletteVariant = "black";
  palette = config.ui.spacelix."${paletteVariant}";
  font = "Terminus";
  utils = (import ./utils.nix) {lib=lib;};
  futhark-vim = pkgs.vimUtils.buildVimPlugin {
    name = "futhark-vim";
    src = inputs.futhark-vim;
  };
in
with palette.withGrey; {

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
        home.file.".xinitrc".text = "exec xmonad";
        home.file.".xmobarrc".text =
          (utils.interpolateColors palette.withGrey
            (builtins.readFile ./resources/xmobarrc.hs)
          );
        home.file."wallpaper.png".source = resources/wallpaper.png;
        home.file.".config/nvim/colors/xelex.vim".source = resources/xelex.vim;
        # home.activation = {
        #   foo = ''
        #     ${inputs.auto-bg.defaultPackage."x86_64-linux"}/bin/gen_wall "${palette.dark.black}" ~/code/misc/img/logos/nixos-pure.png
        #     mv out.png wallpaper.png
        #   '';
        # };
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
	      brave mpv
          gnumake gcc cmake direnv unzip
          tmux ripgrep coreutils
          dmenu lf sxiv vimv
          xcape
          yarn
          slack
          rustc cargo
          cabal2nix cabal-install
          # emacsGcc
          (agda.withPackages [ agdaPackages.standard-library ])
          inputs.nix-boiler.defaultPackage."x86_64-linux"
          godotMonoBin
	    ];
        programs = {
          alacritty = {
            enable = true;
            settings = {
              shell.program = "zsh";
              font = {
                size = 12;
                # size = 9;
                normal.family = font;
                bold.family   = font;
                italic.family = font;
              };
              cursor.style = "Beam";
              colors = {
                primary = {
                  background = black;
                  foreground = white;
                };
                normal = palette.dark;
                bright = palette.light;
                dim    = palette.dark;
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
              e        = "make edit";
	          c        = "cd";
	          g        = "git";
              x        = "exit";
              z        = "zathura";
              nsh      = "nix develop --command zsh";
              nunfree  = "export NIXPKGS_ALLOW_UNFREE=1";
              xc       = "xcape -e 'Super_L=Escape'";
              gcroots  = "nix-store --gc --print-roots | grep home/"; 
              forkterm = "alacritty & disown";
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
              futhark-vim
              haskell-vim
              agda-vim
              conjure
              aniseed
              # soydev langs
              vim-closetag
              coc-nvim
            # coc-tsserver
            # coc-eslint
            # coc-tslint
            # coc-snippets
              coc-prettier
            ];
            extraConfig = lib.fileContents ./resources/init.vim;
          };
          git = {
            enable = true;
            # userEmail = "felix.lipski7@gmail.com";
            # userName = "felix-lipski";
            extraConfig = ''
[user]
  email = "felix.lipski7@gmail.com";
  name = "felix-lipski";
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
              set recolor-lightcolor \${palette.withGrey.black}
              set recolor-darkcolor \${palette.withGrey.white}
              set recolor
            '';
          };
          qutebrowser = {
            enable = true;
            settings = {
              tabs.position = "left";
              colors = {
                tabs = {
                  even = {bg = black; fg = grey;};
                  odd = {bg = black; fg = grey;};
                  selected.even = {bg = white; fg = black;};
                  selected.odd = {bg = white; fg = black;};
                  bar.bg = black;
                  indicator = { stop = green; start = blue; error = red; };
                };
                downloads = {
                  bar.bg = black;
                  error.bg = red;
                  stop.bg = green;
                  start.bg = yellow;
                };
                statusbar = {
                  caret   = { fg = white; bg = cyan;  };
                  insert  = { fg = white; bg = green; };
                  normal  = { fg = white; bg = black; };
                  command = { fg = yellow; bg = black; };
                  url.success = { http.fg = blue; https.fg = green; };
                };
                completion = {
                  category = { bg = black; fg = white; border = { top = white; bottom = white; }; };
                  item.selected = { bg = white; fg = black; match.fg = green; border = { top = white; bottom = white; }; };
                  match.fg = green;
                  even.bg = black;
                  odd.bg = black;
                  fg = [white white blue];
                };
                webpage.darkmode.enabled = true;
                messages = {
                  error   = { fg = black;  bg = red;   border = red; };
                  info    = { fg = blue;   bg = black; border = blue; };
                  warning = { fg = yellow; bg = black; border = yellow; };
                };
              };
              fonts = let 
                bold = "bold 14px 'terminus'"; 
              in {
                tabs.selected = bold;
                tabs.unselected = bold;
                downloads = bold;
                statusbar = bold;
                completion.category = bold;
                completion.entry = bold;
                messages.info = bold;
                messages.error = bold;
                messages.warning = bold;
              };
            };
            searchEngines = {
              n = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
              w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
              aw = "https://wiki.archlinux.org/?search={}";
              nw = "https://nixos.wiki/index.php?search={}";
              g = "https://www.google.com/search?hl=en&q={}";
            };
          };
          vscode.enable = true;
        };
      };
    };
  };
}
