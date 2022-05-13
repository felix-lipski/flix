{ pkgs, inputs, palette }: pkgs.pkgs.stdenv.mkDerivation rec {
  pname        = "wallpaper";
  version      = "0.0.0";
  src = ".";
  dontUnpack = true;
  # pass in the third argument to color the logo
  buildPhase = builtins.concatStringsSep " " [ 
    "${inputs.auto-bg.defaultPackage."x86_64-linux"}/bin/gen_wall"
    ''"${palette.black}"''
    "${./resources/logos/star-antlers-outlined.png}"
    ''"${palette.white}"''
  ];
  installPhase = ''
    mkdir -p $out
    cp out.png $out/wallpaper.png
    '';
}
