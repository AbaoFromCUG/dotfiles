#!/usr/bin/env just --justfile


yay-update:
    #!/usr/bin/env -S zsh
    # yay -Syy --noconfirm

install package: yay-update
    #!/usr/bin/env -S zsh
    # set -euo pipefail
    if (( $+commands[yay] )); then
        if  ! yay -Qi "{{package}}" >/dev/null 3>&1; then
            yay -S --noconfirm {{package}}
            echo install {{package}}
        fi
    elif (( $+commands[brew] )); then
        # echo "check {{package}}"
        if  ! brew ls --version "{{package}}" >/dev/null 3>&1; then
            brew install {{package}}
            echo install {{package}}
        fi
    fi

install-yay:
    #!/usr/bin/env -S zsh --interactive
    set -euo pipefail
    if  (( $+commands[yay] )) ; then exit 0; fi
    mkdir /tmp/cache && cd /tmp/cache
    export GOPROXY=https://goproxy.cn
    sudo pacman -S --needed --noconfirm git go base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    yay -Syuu --noconfirm



link $source $target:
    #!/usr/bin/env -S zsh --interactive
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
    #!/usr/bin/env -S zsh --interactive
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

config-nvim: config-rust (install "neovim") (link "config/nvim" "~/.config/nvim" )
    #!/usr/bin/env -S zsh --interactive
    set -euo pipefail
    nvim --headless -c "Lazy! install" \
        --headless -c "Lazy! load all" \
        --headless -c "TSUpdateSync" \
        -c 'lua print(string.format("Install %s neovim plugins \n", require("lazy").stats().count))' \
        -c "quit"
    
config-zsh: (install "zsh") \
            (install "git") \
            (install "git-lfs") \
            (link "home/zshrc" "~/.zshrc") \
            (link "home/zprofile" "~/.zprofile") \
            (link "home/zshenv" "~/.zshenv") \
            (link "config/shell" "~/.config/shell")
    #!/usr/bin/env -S zsh --interactive
    echo "zsh setup..."

config-tmux: (install "git") (install "tmux") (link "home/tmux.conf.local" "~/.tmux.conf.local")
    #!/usr/bin/env -S zsh --interactive
    if [ ! -d ~/.tmux ] || [ ! -L ~/.tmux.conf ]; then
        rm -rf ~/.tmux
        git clone https://github.com/gpakosz/.tmux.git ~/.tmux
        ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
    fi


config-pyenv: (install "git") (install "pyenv") config-zsh
    #!/usr/bin/env -S zsh --interactive
    set -euo pipefail

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
    pyenv install --skip-existing 3.10 3.11 3.12

config-python: config-pyenv config-zsh (link "config/pip" "~/.config/pip") (config "uv")
    #!/usr/bin/env -S zsh

    if ! pyenv versions | grep -q '3.10'; then
        pyenv install 3.10
    fi
    if ! pyenv versions | grep -q '3.11'; then
        pyenv install 3.11
    fi
    if ! pyenv versions | grep -q '3.12'; then
        pyenv install 3.12
    fi

config-mise: (install "git") (install "usage") (install "mise") (link "config/mise" "~/.config/mise")

config-bun: config-mise
    #!/usr/bin/env -S zsh
    if ! mise ls bun | grep -q 'latest'; then
        mise install bun@latest
    fi

config-rust: config-mise (link "home/cargo/config.toml" "~/.cargo/config.toml")
    #!/usr/bin/env -S zsh
    if ! mise ls rust | grep -q 'stable'; then
        mise install rust@stable
    fi

config-node: config-mise
    #!/usr/bin/env -S zsh
    if ! mise ls node | grep -q '20'; then
        mise install node@20
    fi
    if ! mise ls node | grep -q '22'; then
        mise install node@22
    fi
    if ! mise ls node | grep -q 'latest'; then
        mise install node@latest
    fi
    if ! mise ls pnpm | grep -q 'pnpm'; then
        mise install pnpm
    fi


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


config-dev: \
    config-zsh \
    config-nvim \
    config-mise \
    config-tmux \
    config-python \
    config-node \
    config-rust \
    (config "lazygit") \
    (install "wget") \
    (install "ripgrep") \
    (install "yazi") \
    (install "jq") \
    (install "fd") \
    (install "fzf") \
    (install "bat") \
    (install "eza") \
    (install "zoxide") \
    (install "curl") \
    (install "cmake") \
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


bootstrap-docker: install-yay config-dev
bootstrap-docker-full: bootstrap

bootstrap: install-yay config-dev

bootstrap-desktop: install-yay config-dev config-hypr config-desktop

podman-build:
    #!/usr/bin/env -S zsh --interactive
    podman build -t arch .

podman-build-full:
    #!/usr/bin/env -S zsh --interactive
    podman build -t arch-full . --build-arg RECIPE=bootstrap-docker-full

