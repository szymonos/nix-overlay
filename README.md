# nix-overlay

My [Envy-NX](https://github.com/szymonos/envy-nx) overlays. Each folder under `overlays/` is one overlay, picked
by name.

| Overlay | Installs                                                               |
| ------- | ---------------------------------------------------------------------- |
| `base`  | `shell`, `pwsh`, `oh_my_posh`                                          |
| `k8s`   | `docker`, `k8s_base`, `k8s_dev`, and sofka from its release binaries   |
| `cloud` | `az` (brings `python`), `gcloud`                                       |
| `dev`   | `python`, `nodejs`, `bun`                                              |

## Use it

```bash
nx overlay browse github:szymonos/nix-overlay            # what is here, installs nothing
nx overlay add github:szymonos/nix-overlay k8s cloud     # the overlays you name
nx overlay add github:szymonos/nix-overlay               # pick from a list
nx overlay add github:szymonos/nix-overlay --all         # all of them
nix/setup.sh --overlay github:szymonos/nix-overlay#k8s   # during first setup
```

## Layout

```text
overlays/<name>/
├── README.md        # first line: the description `browse` and the picker show
└── scopes/*.nix     # each file a scope; a `# scopes:` header names standard scopes
lib/                 # shared files, linked or imported from overlays
scripts/, .github/   # repository tooling, never installed
```

`overlays/k8s/scopes/sofka.nix` is a symlink to `lib/sofka.nix`. Link the same file from another overlay to
share it.

## Keeping tools current

`scripts/bump-release.sh <file> <owner>/<repo>` points a release-binary scope at the latest release, taking
the version and per-platform hashes from the release's `SHA256SUMS`. `.github/workflows/bump.yml` runs it
daily and commits the change. For a new tool, copy `lib/sofka.nix`, change the URL and triples, link it from
an overlay, and add a line to the workflow.

Anything here runs on every subscribed machine on its next setup, including whatever an upstream release
ships after an automatic bump.
