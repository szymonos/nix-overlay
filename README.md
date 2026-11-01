# nix-overlay

My [Envy-NX](https://github.com/szymonos/envy-nx) overlay catalog: one folder per group, and the repository
root installs every group at once.

| Folder   | `# scopes:` header             | Extra                                                         |
| -------- | ------------------------------ | ------------------------------------------------------------- |
| `base/`  | `shell pwsh oh_my_posh`        |                                                               |
| `k8s/`   | `docker k8s_base k8s_dev`      | [sofka](https://github.com/nklmilojevic/sofka) from release binaries |
| `cloud/` | `az gcloud` (az brings python) |                                                               |
| `dev/`   | `python nodejs bun`            |                                                               |
| root     | everything above               | `scopes/` holds symlinks to every group's scope files         |

`docker` follows the OS: colima and the docker CLI on macOS; on Linux and WSL it only verifies docker-ce,
which needs root (`wsl/wsl_setup.ps1 -Scope docker`).

## Use it

Envy-NX 1.33.0 or later:

```bash
nx overlay add github:szymonos/nix-overlay              # every group
nx overlay add github:szymonos/nix-overlay --dir k8s    # one group
nx overlay                                              # what is subscribed
```

A subscription with no `--dir` reads only the root `scopes/`, so a new group is added to the root by linking
its scope files there:

```bash
ln -s ../<group>/scopes/<file>.nix scopes/<file>.nix
```

Keep scope file names unique across groups: the root holds them all in one folder.

## Keeping tools current

`scripts/bump-release.sh <file> <owner>/<repo>` points a release-binary scope at the latest release, taking
the version and per-platform hashes from the release's `SHA256SUMS`. `.github/workflows/bump.yml` runs it
daily and commits the change. For a new release-binary tool, copy `k8s/scopes/sofka.nix`, change the URL and
triples, and add a line to the workflow.

Anything here runs on every subscribed machine on its next setup, including whatever an upstream release
ships after an automatic bump.
