#!/usr/bin/env bash

if [ ! -f /tmp/argsparse.sh ]; then
    echo "downloading argsparse module"
    curl -s https://raw.githubusercontent.com/Anvil/bash-argsparse/master/argsparse.sh -o /tmp/argsparse.sh
fi
source /tmp/argsparse.sh

usage() {
    printf "Bootstrap script, supported choices:\n"
    printf "\tterminal: install terminal tools\n"
    printf "\tenv: pyenv+nvm\n"
    printf "\ttexlive: texlive\n"
    printf "\tdevelop: above+develop tools\n"
    printf "\tfull: above+desktop environments\n"
    printf "Beginning of usage:\n"
    argsparse_usage
    printf "End of useage\n"
    exit 16
}

argsparse_use_option choose "choose install specified environments" value mandatory
option_choose_values=(terminal env texlive develop full)

argsparse_parse_options "$@"

args_only=${program_options[choose]}

yay_packages=()
apt_packages=()
additional_commands=()

download() {
    filename=$1
    url=$2
    mkdir -p $(dirname $filename)

    if [ ! -f $1 ]; then
        echo "download $url to $filename"
        curl $url -o $filename
    else
        echo "$filename exists, skip"
    fi
}

setup_nvm() {
    if [ ! -d ~/.nvm ]; then
        echo "installing nvm..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    else
        echo "nvm installed, skip"
    fi
}

setup_pyenv() {
    yay_packages+=(
        penssl
        zlib
        xz
        tk
    )
    apt_packages+=(
        build-essential
        libssl-dev
        zlib1g-dev
        libbz2-dev
        libreadline-dev
        libsqlite3-dev
        curl
        libncursesw5-dev
        xz-utils
        tk-dev
        libxml2-dev
        libxmlsec1-dev
        libffi-dev
        liblzma-dev
    )

    if [ ! -d ~/.pyenv ]; then
        echo "installing pyenv..."
        git clone https://github.com/pyenv/pyenv.git ~/.pyenv
    else
        echo "pyenv installed, skip"
    fi

    pyenv_plugin() {
        name=$1
        git_user=$2
        if [ ! -d ~/.pyenv/plugins/${name} ]; then
            echo "installing ${name}..."
            git clone https://github.com/${git_user}/${name} ~/.pyenv/plugins/${name}
        else
            echo "${name} installed, skip"
        fi
    }

    pyenv_plugin pyenv-virtualenv AbaoFromCUG
    pyenv_plugin pyenv-doctor pyenv
    pyenv_plugin pyenv-update pyenv
    pyenv_plugin pyenv-update pyenv
    pyenv_plugin pyenv-pyright alefpereira
}

setup_rustup() {

    if [ ! -d ~/.rustup ]; then
        echo "installing rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    else
        echo "rustup installed, skip"
    fi
}

setup_tmux() {

    if [ ! -d ~/.tmux ] || [ ! -f ~/.tmux.conf ]; then
        echo "installing oh-my-tmux..."
        if [[ -f ~/.tmux.conf ]]; then
            echo -e "\033[31m backup current .tmux.conf to ~/.tmux.conf.bak \033[0m"
            mv ~/.tmux.conf /tmp/tmux.conf.bak
        fi
        rm -rf ~/.tmux.conf
        git clone https://github.com/gpakosz/.tmux.git ~/.tmux
        ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf
    else
        echo "oh-my-tmux installed, skip"
    fi
}

# --------------choice--------------------

install_terminal() {
    setup_tmux
    yay_packages+=(
        ripgrep
        fzf
        tmux
        zoxide
        lazygit
        fd
        yazi
    )
}

install_env() {
    setup_pyenv
    setup_nvm
    setup_rustup
}

install_develop() {
    yay_packages+=(
        man-db
        cmake
        git
        tk
        ninja
        eigen
        go
        rust
        stylua
    )
}

install_desktop() {
    yay_packages+=(
        hyprland
        hyprpaper
        hyprpicker
        hypridle
        hyprlock
    )
    yay_packages+=(
        xdg-desktop-portal-hyprland
        polkit-gnome
        wofi
        libinput-gestures
        nwg-bar
        waybar
        conky
        cava
        dunst
        wl-clipboard
    )

    # input method
    yay_packages+=(
        fcitx5-configtool
        fcitx5-gtk
        fcitx5-qt
        fcitx5-pinyin-zhwiki
        fcitx5-chinese-addons
        fcitx5-breeze
    )

    # fonts
    yay_packages+=(
        noto-fonts-emoji
        ttf-hack-nerd
        ttf-cascadia-code-nerd
        adobe-source-han-serif-cn-fonts
        adobe-source-han-sans-cn-fonts
        ttf-humor-sans
        ttf-firacode-nerd
    )
    # basic tools
    yay_packages+=(
        pipewire
        pipewire-pulse
        pipewire-jack
        pipewire-audio
        mpd
        mpd-mpris
        playerctl
        pavucontrol

        unarchiver
    )
    # apps
    yay_packages+=(
        clash-for-windows-bin
        firefox
        # wps-office
        feishu-bin
        gimp
        telegram-desktop
        krita
        linuxqq-nt-bwrap
        wechat-universal-bwrap
        vlc
        ario

    )
    # others
    yay_packages+=(
        neofetch
        lolcat
    )

    download ~/Pictures/wallpapers/nature-3058859.jpg https://gitlab.manjaro.org/artwork/wallpapers/wallpapers-2018/-/raw/master/nature-3058859.jpg
    download ~/Pictures/wallpapers/nature-3181144.jpg https://gitlab.manjaro.org/artwork/wallpapers/wallpapers-2018/-/raw/master/nature-3181144.jpg
    additional_commands+=(
        "hyprpm update"
        "hyprpm add https://github.com/hyprwm/hyprland-plugins"
        "hyprpm add https://github.com/levnikmyskin/hyprland-virtual-desktops"
        "hyprpm add https://github.com/KZDKM/Hyprspace.git"
        "hyprpm enable virtual-desktops"

        "systemctl enable --user pipewire"
        "systemctl enable --user pipewire-pulse"
    )
}

install_texlive() {
    yay_packages+=(
        sioyek
        texlive-latex
        texlive-xetex
        texlive-binextra
        texlive-latexrecommended
        texlive-latexextra
        texlive-fontsrecommended
        texlive-fontsextra
        texlive-bibtexextra
        texlive-mathscience

        texlive-langcjk
        texlive-langchinese

        texlive-plaingeneric
    )
}

echo $args_only

if [[ $args_only = terminal ]]; then
    install_terminal
elif [[ $args_only = env ]]; then
    install_env
elif [[ $args_only = texlive ]]; then
    install_texlive
elif [[ $args_only = develop ]]; then
    install_terminal
    install_env
    install_develop
elif [[ $args_only = full ]]; then
    install_terminal
    install_env
    install_develop
    install_desktop
    install_texlive
fi

if [ -n "${yay_packages}" ] && command -v yay >/dev/null 2>&1; then
    echo "please install manually:"
    echo "   yay -S ${yay_packages[@]} --needed"
elif [ -n "${apt_packages}" ] && command -v apt >/dev/null 2>&1; then
    echo "please install manually:"
    echo "   sudo apt install ${apt_packages[@]}"
else
    echo "\033[31m Don't support current system \033[0m"
fi

if [[ -n "${additional_commands[@]}" ]]; then
    echo "please install manually:"
    for command in "${additional_commands[@]}"; do
        echo "    $command"
    done
fi
