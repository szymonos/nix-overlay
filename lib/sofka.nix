# sofka from its GitHub release binaries instead of a source build.
# Bumped by scripts/bump-release.sh (daily workflow); hashes come from the release's SHA256SUMS.
# bins: sofka
{ pkgs }:
let
  version = "0.33.0";
  targets = {
    x86_64-linux = { triple = "x86_64-unknown-linux-musl"; sha256 = "6a1840207cbd4f33afd47c85e4887bab5358a378b042cde685c4dc689abf8b09"; };
    aarch64-linux = { triple = "aarch64-unknown-linux-musl"; sha256 = "8cf7f30a023b7e801112df6aa033d94ec1060d1640a10b74cf5ec57322887f01"; };
    x86_64-darwin = { triple = "x86_64-apple-darwin"; sha256 = "ec1ac62120f7ec7ba407d1420fef5b46f4dfce5050474e06bb5475e0ecf9b65a"; };
    aarch64-darwin = { triple = "aarch64-apple-darwin"; sha256 = "82a813cc1bcebf7f0a6aa2603a26a7d37ba2ccb84dcc6ded39f8a7f57e83bad3"; };
  };
  t = targets.${pkgs.stdenv.hostPlatform.system};
in
[
  (pkgs.stdenvNoCC.mkDerivation {
    pname = "sofka";
    inherit version;
    src = pkgs.fetchurl {
      url = "https://github.com/nklmilojevic/sofka/releases/download/v${version}/sofka-v${version}-${t.triple}.tar.gz";
      inherit (t) sha256;
    };
    # the archive is flat: the binary next to license files
    sourceRoot = ".";
    installPhase = "install -Dm755 sofka $out/bin/sofka";
  })
]
