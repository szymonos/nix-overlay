#!/usr/bin/env bash
: '
# point a release-binary scope file at the latest GitHub release
scripts/bump-release.sh scopes/sofka.nix nklmilojevic/sofka
'
set -euo pipefail

file="$1"
repo="$2"

tag="$(gh release view -R "$repo" --json tagName -q .tagName)"
sums="$(gh release download "$tag" -R "$repo" -p SHA256SUMS -O -)"

# -i.bak works with both GNU and BSD sed
sed -i.bak -E "s/^(  version = \")[^\"]*/\1${tag#v}/" "$file"
for triple in $(sed -nE 's/.*triple = "([^"]+)".*/\1/p' "$file"); do
  sum="$(printf '%s\n' "$sums" | grep -F -- "-$triple.tar.gz" | cut -d' ' -f1)"
  if [ -z "$sum" ]; then
    printf 'no checksum for %s in %s %s\n' "$triple" "$repo" "$tag" >&2
    mv "$file.bak" "$file"
    exit 1
  fi
  sed -i.bak -E "/triple = \"$triple\"/s/sha256 = \"[0-9a-f]*\"/sha256 = \"$sum\"/" "$file"
done
rm -f "$file.bak"
printf '%s -> %s\n' "$file" "$tag"
