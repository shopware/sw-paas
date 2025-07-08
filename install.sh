#!/bin/sh
set -e
main() {
    response=$(curl -s "https://api.github.com/repos/shopware/sw-paas/releases/latest")
    latest_version=$(echo "$response" | grep -m 1 '"name":' | awk -F'"' '{print $4}')
    os=$(uname -s)
    
    arch=$(uname -m)
    case $arch in
        x86_64)  arch="amd64" ;;
        aarch64) arch="arm64" ;;
        armv7l)  arch="arm" ;;
    esac
    
    version=${1:-$latest_version}
    sw_paas_dir="${SW_PAAS_DIR:-$HOME/.sw-paas}"
    bin_dir="$sw_paas_dir/bin"
    tmp_dir="$sw_paas_dir/tmp"
    exe="$bin_dir/sw-paas"
    
    mkdir -p "$bin_dir"
    mkdir -p "$tmp_dir"
    
    if [ -f "$exe" ]; then
        echo "Removing existing Shopware PaaS binary at $exe..."
        rm -f "$exe"
    fi

    download_url="https://github.com/shopware/paas-cli/releases/download/$version/sw-paas_${os}_${arch}"
    echo "Downloading $download_url..."
    curl -q --fail --location --progress-bar --output "$tmp_dir/sw-paas" "$download_url"
    
    chmod +x "$tmp_dir/sw-paas"
    mv "$tmp_dir/sw-paas" "$exe"
    
    echo "Shopware PaaS was installed successfully to $exe."
    
    if command -v sw-paas >/dev/null; then
        echo "Run \`sw-paas auth\` to get started."
    else
        case $SHELL in
        /bin/zsh) shell_profile=".zshrc" ;;
        *) shell_profile=".bash_profile" ;;
        esac
        echo "\n# Shopware PaaS CLI" >> "$HOME/$shell_profile"
        echo "export SW_PAAS_INSTALL=\"$sw_paas_dir\"" >> "$HOME/$shell_profile"
        echo "export PATH=\"\$SW_PAAS_INSTALL/bin:\$PATH\"" >> "$HOME/$shell_profile"
        echo "Open a new terminal or run 'source $HOME/$shell_profile' to start using Shopware PaaS CLI"
        echo "Then, run \`sw-paas auth\` to get started."
    fi
}

main "$1"