{
  lib,
  rustPlatform,
  fetchurl,
  pkg-config,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "zeroclaw";
  version = "0.1.0";

  src = fetchurl {
    url = "https://github.com/zeroclaw-labs/zeroclaw/archive/refs/tags/v0.1.0.tar.gz";
    sha256 = "sha256-I3MiOxeOoffpti3yg50m/jiij8vKtszxkjXpabEXN0U=";
  };

  cargoHash = "sha256-J7yAXEDFYL3banQNe/b8PzRpdRu67jU2W37nSf9Y7RY=";
  nativeBuildInputs = [pkg-config];
  doCheck = false;

  meta = with lib; {
    description = "Fast, small, and fully autonomous AI assistant infrastructure";
    homepage = "https://github.com/zeroclaw-labs/zeroclaw";
    license = licenses.mit;
    mainProgram = "zeroclaw";
    platforms = ["x86_64-linux"];
    maintainers = [atp];
  };
}
