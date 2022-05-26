palette: lib: with palette; {
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
    vv       = "nvim flake.nix";
    gl       = "git log --pretty=oneline";
    gs       = "git status";
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
  history.path = "~/.config/zsh/zsh_history";
}
