let
  black-abs   = "#000000";
  grey-dark   = "#111111";
  grey-slate  = "#1b253a";
  blue-ps     = "#123567";
  teal-dark   = "#073642";
  teal-ms     = "#008080";
  grey-gruv   = "#1e1e1e";
in
let
  spacelix = {
    black   = grey-slate; 
    red     = "#cc0000"; 
    green   = "#77aa00"; 
    yellow  = "#ccbb00"; 
    blue    = "#0066ff"; 
    magenta = "#ff0055"; 
    cyan    = "#00aa77"; 
    white   = "#ffffff"; 
  };
  gruvbox = {
    black   = grey-gruv;
    red     = "#be0f17"; 
    green   = "#868715"; 
    yellow  = "#cc881a"; 
    blue    = "#377375"; 
    magenta = "#a04b73"; 
    cyan    = "#578e57"; 
    white   = "#978771"; 
  };
in
{
  palette = spacelix;
}
