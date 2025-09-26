#!/usr/bin/env just --justfile

set unstable

install-yay:
    #!/usr/bin/env zsh
    set -euo pipefail
    if  (( $+commands[yay] )) ; then exit 0; fi
    mkdir /tmp/cache && cd /tmp/cache
    export GOPROXY=https://goproxy.cn
    sudo pacman -S --needed --noconfirm git go base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    yay -Syuu --noconfirm

install-lazygit:
    #!/usr/bin/env zsh
    if  (( $+commands[lazygit] )) ; then exit 0; fi
    mkdir /tmp/lazygit && cd /tmp/lazygit
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/


install package:
    #!/usr/bin/env zsh
    set -euo pipefail
    if (( $+commands[yay] )); then
        if  ! yay -Qi "{{package}}" >/dev/null 3>&1; then
            yay -S --noconfirm {{package}}
            echo install {{package}}
        fi
    elif (( $+commands[apt-get] )); then
        declare -A alias_names
        alias_names=(["fd"]="fd-find" ["github-cli"]="gh")
        name="${alias_names[{{package}}]:-{{package}}}"

        if ! dpkg -s "$name" >/dev/null 3>&1; then
            sudo apt-get install -y "$name"
        fi
    elif (( $+commands[brew] )); then
        # echo "check {{package}}"
        if  ! brew ls --version "{{package}}" >/dev/null 3>&1; then
            brew install {{package}}
            echo install {{package}}
        fi
    fi

config-ubuntu:
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



link $source $target:
    #!/usr/bin/env zsh
    set -euo pipefail
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

config-nvim: config-rust (install "gcc") (install "neovim") (install "unzip") (link "config/nvim" "~/.config/nvim" )
    #!/usr/bin/env zsh
    set -euo pipefail
    nvim --headless -c "Lazy! install" \
        --headless -c "Lazy! load all" \
        --headless -c "TSUpdateSync" \
        -c 'lua print(string.format("Install %s neovim plugins \n", require("lazy").stats().count))' \
        -c "quit"

config-zsh: (install "zsh") \
            (install "git") \
            (link "home/zshrc" "~/.zshrc") \
            (link "home/zprofile" "~/.zprofile") \
            (link "home/zshenv" "~/.zshenv") \
            (link "config/shell" "~/.config/shell")

config-tmux: (install "git") (install "tmux") (link "home/tmux.conf.local" "~/.tmux.conf.local")
    #!/usr/bin/env zsh
    if [ ! -d ~/.tmux ] || [ ! -L ~/.tmux.conf ]; then
        rm -rf ~/.tmux
        git clone https://github.com/gpakosz/.tmux.git ~/.tmux
        ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
    fi

[unix]
config-pyenv: (install "git") config-zsh
    #!/usr/bin/env zsh

    if  (( $+commands[apt] )) ; then 
        packages=(make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev)
        for package in "${packages[@]}"; do
            just install "$package"
        done
    fi
    set -euo pipefail
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


config-python: config-pyenv config-zsh (link "config/pip" "~/.config/pip") (link "config/uv" "~/.config/uv")
    #!/usr/bin/env zsh
    if  (( ! $+commands[uv] )) ; then 
        curl -LsSf https://astral.sh/uv/install.sh | sh
    fi
    
    pyenv update
    # pyenv install --skip-existing 3.10 3.11 3.12
    pyenv install --skip-existing 3.12

[unix]
config-mise: config-zsh (install "curl") (link "config/mise" "~/.config/mise")
    #!/usr/bin/env -S zsh
    if  (( $+commands[mise] )) ; then exit 0; fi
    curl https://mise.run | sh
    mise use -g usage

[windows]
config-mise: (install "curl") (link "config/mise" "~/.config/mise")
    winget install jdx.mise
    mise use -g usage

config-bun: config-mise
    #!/usr/bin/env zsh
    if ! mise ls bun -i | grep -q 'latest'; then
        mise install bun@latest
    fi

config-rust: config-mise (link "home/cargo/config.toml" "~/.cargo/config.toml")
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

config-git scope="global":
    #!/usr/bin/env zsh
    declare -A keys
    keys=(
        ["user.name"]="John Doe" 
        ["user.email"]="user@example.com"
    )
    for key in "${(@k)keys[@]}"; do
        default_value="$(eval git config get $key)"
        if [ -z "$default_value" ]; then
            read -r "value?please input your git's $key of {{scope}}, e.g. (${keys[$key]}):"
        else
            read -r "value?please input your git's $key of {{scope}} (default: $default_value):"
            value=${value:-$default_value}
        fi
        if [ -z "$value" ]; then 
            echo "you don't input anything, existing..."
            exit 1
        fi;
        git config --{{scope}} $key $value
    done

    echo "Please check your {{scope}} configurations of git:\n"
    git config list

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
    
config-hypr: \
    (install "meson") (install "cpio") \
    (install "hyprland") (install "hyprpaper") (install "hyprpicker") (install "hypridle") (install "hyprlock") \
    (install "xdg-desktop-portal-hyprland") (install "hyprpolkitagent-git") \
    (config "swaync") (install "conky") \
    (config "wofi") (config "waybar") (install "nwg-displays")
    # hyprpm update
    # hyprpm add https://github.com/levnikmyskin/hyprland-virtual-desktops
    # hyprpm enable virtual-desktops

config-wayfire: \
    (link "config/wayfire.ini" "~/.config/wayfire.ini")

config-lazygit: (link "config/lazygit" "~/.config/lazygit")
    #!/usr/bin/env zsh
    if (( $+commands[apt-get] )); then
        just install-lazygit
    else
        just install lazygit
    fi


config-yazi: (link "config/yazi" "~/.config/yazi")
    #!/usr/bin/env zsh
    if (( $+commands[yazi] )); then  exit 0;  fi

    mise install yazi@latest
    mise use -g yazi@latest


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
    (link "config/mimeapps.list" "~/.config/mimeapps.list") \
    (link "config/chromium-flags.conf" "~/.config/chromium-flags.conf") \
    (link "config/chrome-flags.conf" "~/.config/chrome-flags.conf") \
    (link "config/chrome-dev-flags.conf" "~/.config/chrome-dev-flags.conf") \
    (link "config/electron-flags.conf" "~/.config/electron-flags.conf") \
    (link "local/share/applications/file-manager.desktop" "~/.local/share/applications/file-manager.desktop")


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

