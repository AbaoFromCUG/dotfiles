#!/usr/bin/env just --justfile


install package:
    #!/usr/bin/env bash
    set -euo pipefail
    if yay -Qi "^{{package}}$" >/dev/null 2>&1; then
        yay -S --noconfirm {{package}}
    fi

install-yay:
    #!/usr/bin/env bash
    set -euo pipefail
    if  command -v yay &>/dev/null; then exit 0; fi
    mkdir /tmp/cache && cd /tmp/cache
    export GOPROXY=https://goproxy.cn
    sudo pacman -S --needed --noconfirm git go base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    yay -Syuu --noconfirm



link $source $target:
    #!/usr/bin/env bash
    set -euo pipefail
    source=$(realpath "$source")
    target=$(eval echo "$target")
    if [ -e "${target}" ] && [ ! -L "${target}" ]; then
        echo "File ${target} exists ant not a symbolic link of ${source}, failed exists"
        exit 1
    fi
    if [ ! -L ${target} ] || [ ! "$(readlink ${target})"="${target}" ]; then
        ln -s $source $target
    fi

config package $config="": (install package)
    #!/usr/bin/env bash
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

config-nvim  package="neovim-git": (install package) config-rust (link "config/nvim" "~/.config/nvim" )
    #!/usr/bin/env bash
    set -euo pipefail
    nvim --headless -c "Lazy! install" \
        --headless -c "Lazy! load all" \
        --headless -c "TSUpdateSync" \
        -c 'lua print(string.format("Install %s plugins", require("lazy").stats().count))' \
        -c "quit"
    
config-zsh: (install "zsh") \
            (install "git") \
            (install "fzf") \
            (link "home/zshrc" "~/.zshrc") \
            (link "home/zshenv" "~/.zshenv") \
            (link "home/p10k.zsh" "~/.p10k.zsh")
    zsh -c "export TERM=xterm && source ~/.zshrc"

config-tmux: (install "tmux") (install "git") && (link "home/tmux.conf.local" "~/.tmux.conf.local")
    #!/usr/bin/env bash
    if [ ! -d ~/.tmux ] || [ ! -L ~/.tmux.conf ]; then
        rm -rf ~/.tmux
        git clone https://github.com/gpakosz/.tmux.git ~/.tmux
        ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
    fi

config-pyenv: (install "git") config-zsh
    #!/usr/bin/env bash
    set -euo pipefail
    if  command -v pyenv &>/dev/null; then echo "pyenv is exists, ignore"; exit 0; fi

    pyenv_plugin() {
        name=$1
        git_user=$2
        if [ ! -d ~/.pyenv/plugins/${name} ]; then
            echo "installing ${name}..."
            git clone https://github.com/${git_user}/${name} ~/.pyenv/plugins/${name}
        else
            echo "    ${name} installed, skip"
        fi
    }

    git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    pyenv_plugin pyenv-virtualenv AbaoFromCUG
    pyenv_plugin pyenv-doctor pyenv
    pyenv_plugin pyenv-update pyenv
    pyenv_plugin pyenv-pyright alefpereira

config-python: config-pyenv  (link "config/pip" "~/.pip")
    #!/usr/bin/env zsh
    pyenv install --skip-existing 3.10 3.11 3.12

config-rust: (install "rustup")
    rustup default stable

config-asdf: (install "git")
    #!/usr/bin/env zsh
    if  command -v asdf &>/dev/null; then exit 0; fi
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf
    source "$HOME/.asdf/asdf.sh"
    asdf_plugin() {
        name=$1
        repository=$2
        if [ ! -d ~/.asdf/plugins/${name} ]; then
            echo "installing ${name}..."
            asdf plugin-add $name https://github.com/${repository}
        else
            echo "    ${name} installed, skip"
        fi
    }
    asdf_plugin bun cometkim/asdf-bun
    asdf_plugin nodejs asdf-vm/asdf-nodejs

config-node: config-asdf
    asdf install nodejs lts 


config-fzf: config-zsh (install "git") (install "fzf")

config-yazi: (install "yazi") (link "config/yazi" "~/.config/yazi")


config-apps: \
    (config "allacritty") (config "kitty") (config "ghostty") \
    (install "sof-firmware") (install "libva-intel-driver") (install "libva-mesa-driver") \
    (install "networkmanager") (install "curl") (install "wget") \
    (install "pipewire") (install "pipewire-pulse") (install "pipewire-jack") (install "pipewire-audio") \
    (install "bluez-utils") (install "blueman") \
    (install "mpd") (install "mpd-mpris") \
    (install "playerctl") (install "pavucontrol") \
    (install "fcitx5") (install "fcitx5-configtool") \
    (install "fcitx5-pinyin-zhwiki") (install "fcitx5-chinese-addons") \
    (install "fcitx5-gtk") (install "fcitx5-qt")
    echo "install basic tool"

    
config-hypr: \
    (install "meson") (install "cpio") \
    (install "hyprland") (install "hyprpaper") (install "hyprpicker") (install "hypridle") (install "hyprlock") \
    (install "xdg-desktop-portal-hyprland") (install "hyprpolkitagent-git") \
    (install "dunst") (install "conky") \
    (install "wofi") (install "quickshell") (install "nwg-displays")
    hyprpm update
    # hyprpm add https://github.com/levnikmyskin/hyprland-virtual-desktops
    # hyprpm enable virtual-desktops

config-dev: \
    config-zsh \
    config-nvim \
    config-yazi  \
    config-asdf \
    config-fzf \
    config-tmux \
    config-python \
    config-rust \
    (install "git") \
    (install "neovim-git") \
    (install "p7z") \
    (install "yazi") \
    (install "uv") \
    (install "zoxide") \
    (install "eza") \
    (install "fd") \
    (install "wget") \
    (install "curl") \
    (install "cmake") \
    (install "imagemagick") \
    (install "ripgrep")

config-desktop: \
    config-apps \
    config-hypr \
    (link "config/mimeapps.list" "~/.config/mimeapps.list") \
    (link "local/share/applications/file-manager.desktop" "~/.local/share/applications/file-manager.desktop")

bootstrap-docker: install-yay config-dev
bootstrap-docker-full: bootstrap

bootstrap: install-yay config-dev config-hypr config-desktop

podman-build:
    #!/usr/bin/env bash
    host=$(ip route |grep docker|awk '{print $(NF-1)}')
    echo $host
    podman build --env=https_proxy=http://${host}:8092 -t arch .

podman-build-full:
    #!/usr/bin/env bash
    host=$(ip route |grep docker|awk '{print $(NF-1)}')
    echo $host
    podman build --env=https_proxy=http://${host}:8092 -t arch-full . --build-arg RECIPE=bootstrap-docker-full

