FROM archlinux:latest

ARG USER=abao
ARG RECIPE=bootstrap-docker

RUN  echo 'Server = https://mirrors.sustech.edu.cn/archlinux/$repo/os/$arch' |tee -a /etc/pacman.d/mirrorlist && \
    pacman -Syuu --noconfirm && \
    pacman -S just sudo zsh --noconfirm

RUN useradd --groups wheel,audio,input,lp,video --shell /usr/bin/zsh --uid 1000 -m ${USER} && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" |tee -a /etc/sudoers && \
    cat /etc/sudoers
USER ${USER}
WORKDIR /home/${USER}

RUN mkdir /tmp/cache && cd /tmp/cache && \
    export GOPROXY=https://goproxy.cn && \
    sudo pacman -S --needed --noconfirm git go base-devel && \
    git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    yay -Syuu --noconfirm

COPY --chown=abao:abao . .dotfiles

WORKDIR /home/${USER}/.dotfiles

RUN just ${RECIPE}

CMD ["zsh"]






