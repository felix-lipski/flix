palette: font: with palette; {
  enable = true;
  settings = {
    shell.program = "zsh";
    font = {
      size = 12;
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
      normal = { inherit black red green yellow blue cyan white; magenta = orange; };
      dim    = normal;
      bright = normal // { black = grey; };
    };
    window.padding = { x = 4; y = 4; };
  };
}
