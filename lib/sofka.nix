# sofka from its GitHub release binaries instead of a source build.
# Bumped by scripts/bump-release.sh (daily workflow); hashes come from the release's SHA256SUMS.
# bins: sofka
{ pkgs }:
let
  version = "0.36.0";
  targets = {
    x86_64-linux = { triple = "x86_64-unknown-linux-musl"; sha256 = "665aaef8f216c5a8a87b7a0bc592877814c469f5051bf8db334d5d9ab576fe30"; };
    aarch64-linux = { triple = "aarch64-unknown-linux-musl"; sha256 = "083db2f171339bd292fc55a905bf49b3e0b820d7e24655d3970e362a72f13d06"; };
    x86_64-darwin = { triple = "x86_64-apple-darwin"; sha256 = "015fcfe1421dcfa86e33d897b0eaa22122d4094932e91a6a0a234f9c71111932"; };
    aarch64-darwin = { triple = "aarch64-apple-darwin"; sha256 = "0f53cadb3035e1a034cefab1fec7cce65c77764e446c676269683716adb2ee19"; };
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
