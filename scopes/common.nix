# Baseline every machine gets from a flagless `nx setup`.
# docker: colima + docker CLI from nix on macOS; on Linux/WSL docker-ce needs root,
# so it comes from wsl_setup.ps1 -Scope docker (or install_docker.sh) and setup only verifies it.
# scopes: shell pwsh python az nodejs bun gcloud docker k8s_base k8s_dev oh_my_posh
{ pkgs }: with pkgs; [
]
