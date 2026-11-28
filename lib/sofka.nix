# sofka from its GitHub release binaries instead of a source build.
# Bumped by scripts/bump-release.sh (daily workflow); hashes come from the release's SHA256SUMS.
# bins: sofka
{ pkgs }:
let
  version = "0.40.0";
  targets = {
    x86_64-linux = { triple = "x86_64-unknown-linux-musl"; sha256 = "e5011e507bf43b038319d20384354820ecc500c5731e5fdbad580e1c73cf3f74"; };
    aarch64-linux = { triple = "aarch64-unknown-linux-musl"; sha256 = "5b864f9ec30caa177c98065f81e8a77267f1b0c4c4a7936dee257ff472a8f24f"; };
    x86_64-darwin = { triple = "x86_64-apple-darwin"; sha256 = "278490c283ce0201382203a4604df29a1eb7b7267a9f93b45d7025bf1b0f2bc1"; };
    aarch64-darwin = { triple = "aarch64-apple-darwin"; sha256 = "8790af1eef323162b17e31dc21a258eb0b7d8a8bf4d3a6d97288f28cfffb6732"; };
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
