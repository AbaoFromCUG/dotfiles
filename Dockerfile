FROM archlinux:latest

ARG USER_NAME=abao
ARG RECIPE=bootstrap-docker

RUN echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist && \
    cat /etc/pacman.d/mirrorlist && \
    pacman -Syy --noconfirm && \
    pacman -S just sudo zsh git go base-devel --noconfirm

RUN useradd --groups wheel,audio,input,lp,video --shell /usr/bin/zsh --uid 1000 -m ${USER_NAME} && \
    sed -i '/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL$/s/^# //' /etc/sudoers

USER ${USER_NAME}

RUN mkdir /tmp/cache && cd /tmp/cache && \
    export GOPROXY=https://goproxy.cn && \
    git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -s --noconfirm

USER root

RUN cd /tmp/cache/yay && \
    ls -lh && \
    pacman -U --noconfirm *.pkg.tar.zst && \
    rm -rf /tmp/cache &&\
    yay -Syuu --noconfirm


RUN sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen && \
    sed -i 's/^LANG=.*/LANG=en_US.UTF-8/' /etc/locale.conf && \
    locale-gen

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/.dotfiles

COPY --chown=abao:abao . /home/${USER_NAME}/.dotfiles

RUN just ${RECIPE} && \
    zsh --interactive -c "echo Installing..."

CMD ["zsh"]


