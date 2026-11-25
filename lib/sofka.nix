# sofka from its GitHub release binaries instead of a source build.
# Bumped by scripts/bump-release.sh (daily workflow); hashes come from the release's SHA256SUMS.
# bins: sofka
{ pkgs }:
let
  version = "0.39.0";
  targets = {
    x86_64-linux = { triple = "x86_64-unknown-linux-musl"; sha256 = "9d636254fe62f88e803a88b0680b7f944fb96b35c006f3afdf5efa7ceee277eb"; };
    aarch64-linux = { triple = "aarch64-unknown-linux-musl"; sha256 = "831fe462111be18b0fd6ba4d6a37c2003244c8cb9f122631ee71190d30b15055"; };
    x86_64-darwin = { triple = "x86_64-apple-darwin"; sha256 = "ff1da4fed1a6f1fe0b1c3f1c88aaac3ea2e2f8514c200cf0dbe5c0a282039424"; };
    aarch64-darwin = { triple = "aarch64-apple-darwin"; sha256 = "18c36fd2d2b598a1941eb5bf79aa05acddcea0cdecc14d97b9536075f6252099"; };
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
