# sofka from its GitHub release binaries instead of a source build.
# Bumped by scripts/bump-release.sh (daily workflow); hashes come from the release's SHA256SUMS.
# bins: sofka
{ pkgs }:
let
  version = "0.34.0";
  targets = {
    x86_64-linux = { triple = "x86_64-unknown-linux-musl"; sha256 = "034a3f7f170921621613ec01d016967ff8f35b9c42e88c8af2095c1815a117ad"; };
    aarch64-linux = { triple = "aarch64-unknown-linux-musl"; sha256 = "0b2c9f7e7a4d82fcab4b26f3be5c8f1b5c48cbdf5a9b965ee0a00f0e24af6756"; };
    x86_64-darwin = { triple = "x86_64-apple-darwin"; sha256 = "137323c5501dd5b89a361c073a258c979515dc13392b72b5112b7e34bc740204"; };
    aarch64-darwin = { triple = "aarch64-apple-darwin"; sha256 = "dff9ee7d16757f6b0c83a788e750aeeeff49518b3dde4370266ca337fde4eed1"; };
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
