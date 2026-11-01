# nix-overlay

My [Envy-NX](https://github.com/szymonos/envy-nx) overlay: one flagless `nx setup` installs every scope
and tool I use, on any machine.

| Path                           | What it does                                                                  |
| ------------------------------ | ----------------------------------------------------------------------------- |
| `scopes/common.nix`            | `# scopes:` header - the standard scopes every machine gets                   |
| `scopes/sofka.nix`             | [sofka](https://github.com/nklmilojevic/sofka) from release binaries, no build |
| `scripts/bump-release.sh`      | points a release-binary scope at the latest release (version + SHA256SUMS)    |
| `.github/workflows/bump.yml`   | runs the bump daily and commits the change                                    |

## Use it

```bash
git clone https://github.com/szymonos/nix-overlay.git ~/source/repos/szymonos/nix-overlay
nx overlay set ~/source/repos/szymonos/nix-overlay
nx setup
```

Fresh machine, before `nx` exists:

```bash
nix/setup.sh --overlay-dir ~/source/repos/szymonos/nix-overlay   # from an envy-nx checkout
```

WSL: run `wsl/wsl_setup.ps1 -Scope docker` from Windows first (docker-ce needs root), then the commands
above inside the distro. On macOS the `docker` scope installs colima instead.

## Update

```bash
git -C ~/source/repos/szymonos/nix-overlay pull
nx setup     # use nx setup, not nx upgrade, after a # scopes: header change
```

## Add a tool

- In nixpkgs: add its attribute name to the list in `scopes/common.nix` (or a new `scopes/<name>.nix`).
- Release binary only: copy `scopes/sofka.nix`, change the URL and triples, run
  `scripts/bump-release.sh scopes/<name>.nix <owner>/<repo>`, and add a line to `bump.yml`.

Anything placed here runs on every machine on its next setup, including whatever an upstream
release ships after an automatic bump.
