{ pkgs, inputs, palette }:
pkgs.pkgs.stdenv.mkDerivation rec {
  pname        = "wallpaper";
  version      = "0.0.0";
  src = ".";
  dontUnpack = true;
  # pass in the third argument to color the logo
  buildPhase   = ''
  ${inputs.auto-bg.defaultPackage."x86_64-linux"}/bin/gen_wall "${palette.dark.black}" ${./resources/logos/mew.png}
    '';
  installPhase = ''
    mkdir -p $out
    cp out.png $out/wallpaper.png
    '';
}
