rec {
  spacelix-base = {
    red     = "#cc0000"; 
    green   = "#77aa00"; 
    yellow  = "#ccbb00"; 
    blue    = "#0066ff"; 
    magenta = "#ff0055"; 
    cyan    = "#00aa77"; 
    white   = "#ffffff"; 
  };

  altred = "#dc322f";

  spacelix-slate  = spacelix-base // { black = "#1b253a"; };
  spacelix-dark   = spacelix-base // { black = "#111111"; };
  spacelix-black  = spacelix-base // { black = "#000000"; };
  spacelix-ocean  = spacelix-base // { black = "#012456"; red = altred; };
  spacelix-sea    = spacelix-base // { black = "#073642"; red = altred; };
}
