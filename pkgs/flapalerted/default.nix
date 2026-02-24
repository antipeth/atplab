{
  lib,
  stdenvNoCC,
  fetchurl,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "flapalerted";
  version = "4.3.0";
  src = fetchurl {
    url = "https://github.com/Kioubit/FlapAlerted/releases/download/v4.3.0/FlapAlerted_v4.3.0_linux_amd64";
    sha256 = "sha256-NMXsPCg9PprMbnjRYSSi9/om0BFPmcHScuI9hwZxFSc=";
  };
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/flapalerted
    chmod +x $out/bin/flapalerted
    runHook postInstall
  '';
  meta = with lib; {
    description = "BGP Update based flap detection";
    homepage = "https://github.com/Kioubit/FlapAlerted";
    license = licenses.free;
    platforms = ["x86_64-linux"];
    maintainers = [atp];
  };
}
