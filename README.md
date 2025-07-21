# sw-paas

Shopware PaaS Native CLI Releases

## Installation

### Quick Install (Recommended)

Run the following command to install the latest version of Shopware PaaS Native CLI:

```bash
curl -L https://install.sw-paas-cli.shopware.systems | sh
```

### Install Specific Version

To install a specific version, pass the version as an argument:

```bash
curl -L https://install.sw-paas-cli.shopware.systems | sh -s v0.0.30
```

### Manual Installation

1. Download the appropriate binary for your system from the [releases page](https://github.com/shopware/sw-paas/releases)
2. Make it executable: `chmod +x sw-paas_<OS>_<ARCH>`
3. Move it to a directory in your PATH: `mv sw-paas_<OS>_<ARCH> /usr/local/bin/sw-paas`

### What the installer does

The installation script will:

- Download the latest version (or specified version) from GitHub releases
- Install the binary to `~/.sw-paas/bin/sw-paas`
- Add the installation directory to your PATH (if not already present)
- Support for macOS (Darwin) and Linux on x86_64, arm64, and i386 architectures

### Environment Variables

- `SW_PAAS_DIR`: Custom installation directory (defaults to `~/.sw-paas`)

### Getting Started

After installation, run:

```bash
sw-paas auth
```

### Uninstall

To remove Shopware PaaS Native CLI:

```bash
rm -rf ~/.sw-paas
```

Then remove the following lines from your shell profile (`~/.zshrc` or `~/.bash_profile`):

```bash
# Shopware PaaS CLI
export SW_PAAS_INSTALL="$HOME/.sw-paas"
export PATH="$SW_PAAS_INSTALL/bin:$PATH"
```
