{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  ...
}:
stdenvNoCC.mkDerivation rec {
  pname = "headscale-ui";
  version = "2025.08.23";
  src = fetchurl {
    url = "https://github.com/gurucomputing/headscale-ui/releases/download/2025.08.23/headscale-ui.zip";
    sha256 = "sha256-1/LMHZoXe/rvQJNYt37QriBLMjEyv9aHi+teaxaenYI=";
  };

  nativeBuildInputs = [unzip];

  installPhase = ''
    runHook preInstall
    unzip ${src}
    mkdir -p $out/web
    cp -r web/* $out/web/
    runHook postInstall
  '';

  meta = with lib; {
    description = "A web frontend for the headscale Tailscale-compatible coordination server";
    homepage = "https://github.com/gurucomputing/headscale-ui";
    license = licenses.free;
    platforms = ["x86_64-linux"];
    maintainers = [atp];
  };
}
