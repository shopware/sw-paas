#!/bin/sh
set -e
main() {
    response=$(curl -s "https://api.github.com/repos/shopware/sw-paas/releases/latest")
    latest_version=$(echo "$response" | grep -m 1 '"name":' | awk -F'"' '{print $4}')
    os=$(uname -s)
    
    arch=$(uname -m)
    case $arch in
        x86_64)  arch="x86_64" ;;
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

    download_url="https://github.com/shopware/sw-paas/releases/download/$version/sw-paas_${os}_${arch}.tar.gz"
    echo "Downloading $download_url..."
    curl -q --fail --location --progress-bar --output "$tmp_dir/sw-paas.tar.gz" "$download_url"
    
    echo "Extracting archive..."
    tar -xzf "$tmp_dir/sw-paas.tar.gz" -C "$tmp_dir"
    
    chmod +x "$tmp_dir/sw-paas"
    mv "$tmp_dir/sw-paas" "$exe"
    
    rm -f "$tmp_dir/sw-paas.tar.gz"
    
    echo "Shopware PaaS was installed successfully to $exe."
    
    if command -v sw-paas >/dev/null; then
        echo "Run \`sw-paas auth\` to get started."
    else
        case $(basename "$SHELL") in
        zsh)  shell_profile=".zshrc" ;;
        bash) shell_profile=".bash_profile" ;;
        *)    shell_profile=".profile" ;;
        esac
        profile_path="$HOME/$shell_profile"
        if ! grep -qs "# Shopware PaaS CLI" "$profile_path"; then
            printf '\n# Shopware PaaS CLI\n' >> "$profile_path"
            printf 'export SW_PAAS_INSTALL="%s"\n' "$sw_paas_dir" >> "$profile_path"
            printf 'export PATH="$SW_PAAS_INSTALL/bin:$PATH"\n' >> "$profile_path"
        fi
        echo "Open a new terminal or run 'source $profile_path' to start using Shopware PaaS CLI"
        echo "Then, run \`sw-paas auth\` to get started."
    fi
}

main "$1"