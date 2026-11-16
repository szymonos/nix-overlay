# sofka from its GitHub release binaries instead of a source build.
# Bumped by scripts/bump-release.sh (daily workflow); hashes come from the release's SHA256SUMS.
# bins: sofka
{ pkgs }:
let
  version = "0.37.0";
  targets = {
    x86_64-linux = { triple = "x86_64-unknown-linux-musl"; sha256 = "00fc1ce1c3144197f5c1edfa55ec0fce53a4679280622ef7dd63bb08dcc2c4a3"; };
    aarch64-linux = { triple = "aarch64-unknown-linux-musl"; sha256 = "f36b9887e76d33835635dbf19bfc29a68a735a4d26a0a1a3e37f2915e3911feb"; };
    x86_64-darwin = { triple = "x86_64-apple-darwin"; sha256 = "8d587eebb2191913cc877530c817a4454ce7e5610f36e1c31e3c3beb3af2e163"; };
    aarch64-darwin = { triple = "aarch64-apple-darwin"; sha256 = "1a9076ecdf78a438a36406991c16b27a8fc84eab90832cd97ab4742a657bfebb"; };
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
