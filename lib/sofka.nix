# sofka from its GitHub release binaries instead of a source build.
# Bumped by scripts/bump-release.sh (daily workflow); hashes come from the release's SHA256SUMS.
# bins: sofka
{ pkgs }:
let
  version = "0.38.0";
  targets = {
    x86_64-linux = { triple = "x86_64-unknown-linux-musl"; sha256 = "968610905d65fd10bbd94048b80692a2c155d4be36f40c3f569abeaa819b52b4"; };
    aarch64-linux = { triple = "aarch64-unknown-linux-musl"; sha256 = "05ed455339c0696277d13fc284efbe58450a75940898c15c8f244a8302d0ae3a"; };
    x86_64-darwin = { triple = "x86_64-apple-darwin"; sha256 = "7994790f9098944634efdddfe59f7b7fae28265616a5cecff838db344a6a751e"; };
    aarch64-darwin = { triple = "aarch64-apple-darwin"; sha256 = "bf0854dcfd09aed13739f3bd1d1e6a025100a7f758574c123e39993066ad83e2"; };
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
