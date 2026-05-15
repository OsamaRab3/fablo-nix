# Fablo Nix Package

A [Nix](https://nixos.org/) package for [Fablo](https://github.com/hyperledger-labs/fablo) - a simple tool to generate Hyperledger Fabric networks and run them on Docker.

## Prerequisites

Enable Nix flakes:

```bash
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

## Installation

### Install from GitHub (Recommended)

```bash
# Install to your Nix profile
nix profile add github:OsamaRab3/fablo-nix

# Run fablo directly
fablo --help
```

### Run without installation

```bash
nix run github:OsamaRab3/fablo-nix -- <command>
# nix run github:OsamaRab3/fablo-nix -- init node
# nix run github:OsamaRab3/fablo-nix -- up

```

## Requirements

- **Docker** - Fablo requires Docker to run Hyperledger Fabric networks (must be installed and running on your system)

Note: Docker is **not** included in the Nix package as it's a runtime dependency that should be managed separately on your system.

## Advantages of Using Nix

- **Reproducibility**: Exact version and hash are pinned, ensuring consistent builds
- **Declarative**: Version and dependencies are explicitly defined in the Nix expression
- **Isolation**: No conflicts with system-wide installations
- **Cross-Platform**: Works on Linux and macOS with consistent behavior
- **Easy Updates**: Simple to update by changing version and hash in the flake
- **No Installation**: Can run directly without installation using `nix run`

## Links

- [Fablo GitHub Repository](https://github.com/hyperledger-labs/fablo)

