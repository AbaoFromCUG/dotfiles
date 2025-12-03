#!/usr/bin/env just --justfile

set unstable


init-ubuntu:
    #!/usr/bin/env bash
    type -p add-apt-repository >/dev/null || (sudo apt-get update && sudo apt-get install software-properties-common -y)
    sudo add-apt-repository ppa:neovim-ppa/stable -y
    sudo add-apt-repository ppa:neovim-ppa/unstable -y
    type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)
    mkdir -p -m 755 /etc/apt/keyrings
    out=$(mktemp)
    wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg 
    cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null 
    sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg 
    sudo mkdir -p -m 755 /etc/apt/sources.list.d 
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt-get update

init-archlinux:
    #!/usr/bin/env zsh
    echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' | tee -a /etc/pacman.d/mirrorlist
    pacman -Syy --noconfirm

link $source $target="":
    #!/usr/bin/env zsh
    set -euo pipefail
    if [ -z "$target" ]; then
        if [[ "$source" == home/* ]]; then
            target="~/.${source#home/}"
        elif [[ "$source" == etc/* ]]; then
            target="/$source"
        else
            target="~/.$source"
        fi
    fi

    source=$(realpath "$source")
    target=$(eval echo "$target")
    if [ -e "${target}" ] && [ ! -L "${target}" ]; then
        echo "File ${target} exists and not a symbolic link of ${source}, failed exists"
        exit 1
    fi
    if [ ! -L ${target} ] || [ ! "$(readlink ${target})"="${target}" ]; then
        mkdir -p $(dirname ${target})
        ln -s $source $target
    fi

config package $config="": (install package)
    #!/usr/bin/env zsh
    set -euo pipefail
    if [ -z "$config" ]; then
        config={{package}}
    fi
    target="~/.config/${config}"
    source="config/${config}"

    source=$(realpath "$source")
    target=$(eval echo "$target")

    if [ -e "${target}" ] && [ ! -L "${target}" ]; then
        echo "File ${target} exists ant not a symbolic link of ${source}, failed exists"
        exit 1
    fi
    if [ ! -L ${target} ] || [ ! "$(readlink ${target})"="${target}" ]; then
        ln -s $source $target
    fi

config-nvim: config-rust (install "gcc") (install "neovim") (install "unzip") (link "config/nvim")
    #!/usr/bin/env zsh
    set -euo pipefail
    if (( ! $+commands[tree-sitter] )); then 
        mise install tree-sitter
        mise use -g tree-sitter
    fi

    if (( ! $+commands[ruff] )); then 
        mise install ruff
        mise use -g ruff
    fi

    nvim --headless -c "Lazy! install" \
        --headless -c "Lazy! load all" \
        --headless -c "TSUpdateSync" \
        -c 'lua print(string.format("Install %s neovim plugins \n", require("lazy").stats().count))' \
        -c "quit"



[unix]
config-pyenv: (install "git") config-zsh
    #!/usr/bin/env zsh

    if  (( $+commands[apt] )) ; then 
        packages=(make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev)
        for package in "${packages[@]}"; do
            just install "$package"
        done
    elif  (( $+commands[yay] )) ; then 
        packages=(base-devel openssl zlib xz tk zstd)
        for package in "${packages[@]}"; do
            just install "$package"
        done
    fi
    if  (( $+commands[pyenv] )) || [ -d ~/.pyenv ]; then exit 0; fi
    git clone https://github.com/pyenv/pyenv.git ~/.pyenv

    pyenv_plugin() {
        name=$1
        git_user=$2
        if [ ! -d ~/.pyenv/plugins/${name} ]; then
            echo "installing ${name}..."
            git clone https://github.com/${git_user}/${name} ~/.pyenv/plugins/${name}
        fi
    }

    pyenv_plugin pyenv-virtualenv AbaoFromCUG
    pyenv_plugin pyenv-doctor pyenv
    pyenv_plugin pyenv-update pyenv
    pyenv_plugin pyenv-pyright alefpereira


config-python: config-pyenv config-zsh (link "config/pip") (link "config/uv")
    #!/usr/bin/env zsh
    if  (( ! $+commands[uv] )) ; then 
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
    
    pyenv update
    # pyenv install --skip-existing 3.10 3.11 3.12
    pyenv install --skip-existing 3.12

[unix]
config-mise: config-zsh (install "curl") (link "config/mise")
    #!/usr/bin/env -S zsh
    if  (( ! $+commands[mise] )); then 
        curl https://mise.run | sh
    fi
    mise install

[windows]
config-mise: (install "curl") (link "config/mise")
    winget install jdx.mise
    mise install

config-rust: config-mise (link "home/cargo/config.toml")
    #!/usr/bin/env zsh
    if ! mise ls rust -i | grep -q 'stable'; then
        mise install rust@stable
    fi
    if ! mise ls rust -i | grep -q 'nightly'; then
        mise install rust@nightly
    fi

config-node: config-mise
    #!/usr/bin/env zsh
    versions=("20" "22" "24")
    for version in ${versions[@]}; do
        if ! mise ls node -i | grep -q "${version}"; then
            mise install node@${version}
        fi
    done
    if ! mise ls pnpm -i | grep -q 'pnpm'; then
        mise install pnpm
    fi


config-fonts:
	(install nerd-fonts)

config-apps: \
    (config "alacritty") (config "kitty") (config "ghostty") \
    (install "sof-firmware") (install "libva-intel-driver") (install "libva-mesa-driver") \
    (install "networkmanager") (install "curl") (install "wget") \
    (install "pipewire") (install "pipewire-pulse") (install "pipewire-jack") (install "pipewire-audio") \
    (install "bluez-utils") (install "blueman") \
    (config "mpd") (install "mpd-mpris") \
    (install "playerctl") (install "pavucontrol") \
    (install "fcitx5") (install "fcitx5-configtool") \
    (install "fcitx5-pinyin-zhwiki") (install "fcitx5-chinese-addons") \
    (install "fcitx5-gtk") (install "fcitx5-qt")
    echo "install basic tool"

config-office: \
    (install "wemeet-bwrap") (install "feishu-portable")

config-user:
    sudo usermod -aG audio,input,lp,video,cups,docker $USER

config-hypr: \
    (install "meson") (install "cpio") \
    (install "hyprland") (install "hyprpaper") (install "hyprpicker") (install "hypridle") (install "hyprlock") \
    (install "xdg-desktop-portal-hyprland") (install "hyprpolkitagent") (install "hyprdynamicmonitors-bin") \
    (config "swaync") (install "conky") (link "config/hypr") (link "config/hyprdynamicmonitors") \
    (link "local/bin/hyprlayout") \
    (link "local/bin/waybarctl") \
    (link "local/bin/widgetctl") \
    (link "local/bin/mpdctl") \
    (config "wofi") (config "waybar") (config "nwg-bar") (install "nwg-displays") (install "grimblast-git")
    # hyprpm update
    # hyprpm add https://github.com/levnikmyskin/hyprland-virtual-desktops
    # hyprpm enable virtual-desktops
    systemctl --user enable --now hyprpolkitagent
    systemctl --user enable --now pipewire
    systemctl --user enable --now pipewire-pulse
     

config-wayfire: \
    (link "config/wayfire.ini")

config-lazygit: config-mise (link "config/lazygit")

config-yazi: config-mise (link "config/yazi")
    #!/usr/bin/env zsh
    ya pkg install

config-dev: \
    config-zsh \
    config-nvim \
    config-mise \
    config-tmux \
    config-python \
    config-node \
    config-bun \
    config-rust \
    config-lazygit \
    config-yazi \
    (install "wget") \
    (install "ripgrep") \
    (install "jq") \
    (install "fd") \
    (install "fzf") \
    (install "bat") \
    (install "eza") \
    (install "zoxide") \
    (install "curl") \
    (install "cmake") \
    (install "man-db") \
    (install "github-cli") \
    (install "imagemagick")

config-desktop: \
    config-apps \
    config-hypr \
    (link "config/mimeapps.list") \
    (link "config/chromium-flags.conf") \
    (link "config/chrome-flags.conf") \
    (link "config/chrome-dev-flags.conf") \
    (link "config/electron-flags.conf") \
    (link "local/share/applications/file-manager.desktop")


bootstrap-docker: config-dev
bootstrap-docker-full: bootstrap

bootstrap: install-yay config-dev

bootstrap-desktop: install-yay config-dev config-hypr config-desktop

podman-build:
    #!/usr/bin/env zsh
    podman build -t arch .

podman-build-full:
    #!/usr/bin/env zsh
    podman build -t arch-full . --build-arg RECIPE=bootstrap-docker-full

