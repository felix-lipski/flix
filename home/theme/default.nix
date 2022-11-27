{ pkgs, palette }: pkgs.pkgs.stdenv.mkDerivation rec {
  pname        = "flix-theme";
  version      = "0.0.1";
  src = ".";
  dontUnpack = true;
  buildInputs = [
        (pkgs.python39.buildEnv.override {
          extraLibs = with pkgs.python39Packages; [
            colorthief
            pillow
          ];
        })];
  buildPhase = '' 
    python ${./dict.py} '${builtins.toJSON palette}' > palette.dict

    awk -f ${./foo.awk}  palette.dict ${./qute.css}  > qute.css
    awk -f ${./foo.awk}  palette.dict ${./doom.el }  > doom.el
    awk -f ${./foo.awk}  palette.dict ${./vsc.json}  > vsc.json

	python ${./wallpaper.py} ${./wallpaper.png} wallpaper.png '${builtins.toJSON palette}'
    '';
  installPhase = ''
    mkdir -p $out
    cp qute.css $out/qute.css
    cp doom.el  $out/doom.el
    cp vsc.json $out/vsc.json
    cp wallpaper.png $out/wallpaper.png
    '';
}
