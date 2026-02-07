{
  lib,
  stdenvNoCC,
  fetchurl,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "vigil-agent";
  version = "2.1.0";
  src = fetchurl {
    url = "https://github.com/pineappledr/vigil/releases/download/v2.1.0/vigil-agent-linux-amd64";
    sha256 = "sha256-hzSJzZ7UgLmPeRjKoOn8Ixsi3CdqBaNh+HCjJiPea4Y=";
  };
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/vigil-agent
    chmod +x $out/bin/vigil-agent
    runHook postInstall
  '';
  meta = with lib; {
    description = "Vigil is a modern, lightweight, and open-source server monitoring system, that provides real-time S.M.A.R.T. health tracking.";
    homepage = "https://github.com/pineappledr/vigil";
    license = licenses.free;
    platforms = ["x86_64-linux"];
    maintainers = [atp];
  };
}
