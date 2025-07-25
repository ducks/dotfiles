{
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "berkeley-mono-font";
  version = "1.0";
  src = /home/ducks/.config/fonts/berkeley-mono;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype/
    if [ -d "$src" ]; then
      cp -r $src/*.ttf $out/share/fonts/truetype/
    else
      echo "No fonts found in $src/fonts"
      exit 0
    fi
  '';
}
