# sofka from its GitHub release binaries instead of a source build.
# Bumped by scripts/bump-release.sh (daily workflow); hashes come from the release's SHA256SUMS.
# bins: sofka
{ pkgs }:
let
  version = "0.35.1";
  targets = {
    x86_64-linux = { triple = "x86_64-unknown-linux-musl"; sha256 = "f22e292535f11c0ec9f01dc7b28a9dd2ce11495941d8e014a129c2343c218660"; };
    aarch64-linux = { triple = "aarch64-unknown-linux-musl"; sha256 = "1e229eccd71bc7b545b449e134d6ed76348692299c23414b949eb6e98541ffe6"; };
    x86_64-darwin = { triple = "x86_64-apple-darwin"; sha256 = "1e0776eb5cd38dc9b24d1cdf6502eb90be7179f813fe3ac80d7528e393c5ff5a"; };
    aarch64-darwin = { triple = "aarch64-apple-darwin"; sha256 = "6b51127bb918b32d6abc9aed940c2ffcf99e595c173fd48f432ec3591647c5c1"; };
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
