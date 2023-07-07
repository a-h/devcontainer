# VS Code DevContainer

DevContainer containing development tools I use.

## Getting started

The host machine must have:

* VS Code
  * https://code.visualstudio.com/download
* WSL 2 (if running Windows)
  * https://ripon-banik.medium.com/how-to-install-wsl2-offline-b470ab6eaf0e
* DevContainers VS Code Extension
  * Download from https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers


## Tasks

### build

```
docker build --progress=plain -t devcontainer:latest .
```

### run

```
docker run --rm -it devcontainer:latest
```

### nix-build

```
nix build .#docker
docker load < result
```

### nix-run

```
docker run --rm -it devcontainer-nix:latest
```

### nix-test

Use the https://code.visualstudio.com/docs/devcontainers/devcontainer-cli to run the local Devcontainer built with Nix.

```
devcontainer up --remove-existing-container --workspace-folder ./example-project
```
