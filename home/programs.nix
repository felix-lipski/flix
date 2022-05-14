palette: font: fontSize: lib: pkgs: with palette; {
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
}
