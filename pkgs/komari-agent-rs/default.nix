{
  lib,
  stdenvNoCC,
  fetchurl,
  ...
}:
stdenvNoCC.mkDerivation {
  pname = "komari-agent-rs";
  version = "latest";
  src = fetchurl {
    url = "https://github.com/GenshinMinecraft/komari-monitor-rs/releases/download/latest/komari-monitor-rs-linux-x86_64-musl";
    sha256 = "sha256-cjggc5/KHDJmrRAmDECb/8zMPuhXBXvw0QfzsJdzK2s=";
  };
  dontUnpack = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp $src $out/bin/komari-agent-rs
    chmod +x $out/bin/komari-agent-rs
    runHook postInstall
  '';
  meta = with lib; {
    description = "Komari Monitor Agent in Rust";
    homepage = "https://github.com/GenshinMinecraft/komari-monitor-rs";
    license = licenses.free;
    platforms = ["x86_64-linux"];
    maintainers = [atp];
  };
}
