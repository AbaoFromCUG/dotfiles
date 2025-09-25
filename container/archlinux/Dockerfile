FROM archlinux:latest

ARG USER_NAME=abao
ARG RECIPE=bootstrap-docker

RUN echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' | tee -a /etc/pacman.d/mirrorlist && \
    pacman -Syy --noconfirm && \
    pacman -S just sudo zsh git go base-devel --noconfirm && \
    useradd --groups wheel --shell /usr/bin/zsh --uid 1000 -m ${USER_NAME} && \
    sed -i '/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL$/s/^# //' /etc/sudoers && \
    sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen && \
    sed -i 's/^LANG=.*/LANG=en_US.UTF-8/' /etc/locale.conf && \
    locale-gen && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/* /tmp/* /var/tmp/*

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/.dotfiles

COPY --chown=abao:abao . /home/${USER_NAME}/.dotfiles

RUN sudo pacman -Syy && \
    just install-yay && \
    just ${RECIPE} && \
    zsh --interactive -c "echo Installing..." && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/* /tmp/* /var/tmp/*

USER root

RUN sed -i '/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL$/s/^/# /' /etc/sudoers && \
    sed -i '/^# %wheel ALL=(ALL:ALL) ALL$/s/^# //' /etc/sudoers

USER ${USER_NAME}

CMD ["zsh"]


