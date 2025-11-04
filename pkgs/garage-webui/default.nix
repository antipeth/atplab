{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  glibc,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "garage-webui";
  version = "1.1.0";
  src = fetchurl {
    url = "https://github.com/khairul169/garage-webui/releases/download/1.1.0/garage-webui-v1.1.0-linux-amd64";
    sha256 = "sha256-GAtZRpV5KPbO8Wg8SEpp07bE8OwA4TJAKGP8j/gk50Y=";
  };

  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [glibc];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/garage-webui
    chmod +x $out/bin/garage-webui
    runHook postInstall
  '';

  meta = with lib; {
    description = "WebUI for Garage Object Storage Service";
    homepage = "https://github.com/khairul169/garage-webui";
    license = licenses.free;
    platforms = ["x86_64-linux"];
    maintainers = [atp];
  };
}
