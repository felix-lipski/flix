palette: font: fontSize: lib: pkgs: config: with palette; {
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
      vim-nix vim-ocaml  agda-vim conjure aniseed ats-vim latex-box futhark-vim
      purescript-vim dhall-vim vim-liquid
      nerdtree
      zen-mode-nvim
# haskell-vim
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
      set recolor-keephue
      set guioptions none
    '';
  };
  rofi =
    let 
      mkLiteral = value: {
        _type = "literal";
        inherit value;
      }; 
    in {
      enable = true;
      font = "Terminus 12";
      theme = {
        "*" = {
          background-color = mkLiteral black;
          foreground-color = mkLiteral white;
          text-color = mkLiteral white;
          highlight = mkLiteral ("underline bold " + green);
        };
        "window" = {
          border = 1;
          border-color = mkLiteral white;
          padding = 2;
        };
        "prompt" = {
          margin = mkLiteral "0px 10px 0px 10px";
        };
      };
  };
  lf = {
    enable = true;
    commands = {
      open = lib.fileContents ./resources/lfopen;
    };
  };
  alacritty = (import ./alacritty.nix) palette font;
  zsh = (import ./zsh.nix) palette lib pkgs;
  qutebrowser = (import ./qute.nix) palette font fontSize;
  vscode.enable = true;
}
