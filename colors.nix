rec {
  gruvbox = {
    black   = "#1e1e1e";
    red     = "#be0f17"; 
    green   = "#868715"; 
    yellow  = "#cc881a"; 
    blue    = "#377375"; 
    magenta = "#a04b73"; 
    cyan    = "#578e57"; 
    white   = "#978771"; 
  };

  named = (import ./spacelix.nix).spacelix-black;

  interpolateColors = builtins.replaceStrings 
    (map (x: "#" + x) (builtins.attrNames named))
    (builtins.attrValues named);
}
