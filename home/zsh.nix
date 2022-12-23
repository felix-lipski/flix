palette: lib: pkgs: with palette; {
  enable = true;
  dotDir = ".config/zsh";
  shellAliases = let
    findFlake = pkgs.writeShellScript "findFlake" ( lib.fileContents ./resources/find-flake.sh );
  in {
    ls       = "ls --color";
    l        = "ls -la";
    v        = "nvim";
    m        = "make";
    c        = "cd";
    g        = "git";
    x        = "exit";
    z        = "zathura";
    s        = "sxiv";
    vv       = "nvim flake.nix";
    gl       = "git log --pretty=oneline";
    gs       = "git status";
    nsh      = "nix develop --command zsh";
    nunfree  = "export NIXPKGS_ALLOW_UNFREE=1";
    xc       = "xcape -e 'Super_L=Escape'";
    gcroots  = "nix-store --gc --print-roots | grep home/"; 
    forkterm = "alacritty & disown";
    ssha     = "eval `ssh-agent`; ssh-add";
    vm       = "v Makefile";
    nlf      = "grep /nix/store/ /tmp/ech.log | awk '!x[$0]++' | rofi -dmenu | xargs lf";
    "1"      = "nvim -c':e#<1'";
    "2"      = "nvim -c':e#<2'";
    "3"      = "nvim -c':e#<3'";
    foo      = "${findFlake} | xargs nvim";
    shutup   = "shutdown now";
  };
  localVariables = {
    PROMPT = "%B%F{blue}%n%f %F{green}%~%f%b ";
    EDITOR = "nvim";
    F = "https://github.com/felix-lipski/";
    THEME_BG = palette.black;
    THEME_FG = palette.white;
  };
  initExtra = lib.fileContents ./resources/zshrc;
  history.path = "~/.config/zsh/zsh_history";
}
