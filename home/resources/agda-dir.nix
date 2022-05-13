{ pkgs }:
pkgs.pkgs.stdenv.mkDerivation rec {
  pname        = "agda-dir";
  version      = "0.0.0";
  src = ".";
  dontUnpack = true;
  buildPhase   = ''
    echo "${pkgs.agdaPackages.standard-library}" > libraries
    echo "standard-library" > defaults
  '';
  installPhase = ''
    mkdir -p $out
    cp libraries $out
    cp defaults $out
  '';
}
