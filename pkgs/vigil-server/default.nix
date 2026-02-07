{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  glibc,
  gnutar,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "vigil-server";
  version = "2.1.0";
  src = fetchurl {
    url = "https://github.com/pineappledr/vigil/releases/download/v2.1.0/vigil-server-linux-amd64";
    sha256 = "sha256-4P1bqdOVs4zVQIn3QInteh2wHtQQy2+WAC82nWcoBps=";
  };
  web = fetchurl {
    url = "https://github.com/pineappledr/vigil/archive/refs/tags/v2.1.0.tar.gz";
    sha256 = "sha256-kjOrNYvhUicayuRqWwop/8AXuRpfdy0gnty28Q51ud0=";
  };
  nativeBuildInputs = [autoPatchelfHook];
  buildInputs = [glibc gnutar];
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/web
    cp $src $out/bin/vigil-server
    chmod +x $out/bin/vigil-server
    tar -xzf $web
    cp -r vigil-2.1.0/web/* $out/web/
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
