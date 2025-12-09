FROM archlinux:latest

ARG USER_NAME=abao
ARG USER_PASSWORD=password
ARG RECIPE=bootstrap-docker

RUN echo 'Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' | tee -a /etc/pacman.d/mirrorlist && \
    pacman -Syy --noconfirm && \
    pacman -S mise sudo zsh git go base-devel --noconfirm && \
    useradd --groups wheel --shell /usr/bin/zsh --uid 1000 -m ${USER_NAME} && \
    sed -i '/^# %wheel ALL=(ALL:ALL) NOPASSWD: ALL$/s/^# //' /etc/sudoers && \
    sed -i '/^#en_US.UTF-8 UTF-8/s/^#//' /etc/locale.gen && \
    sed -i 's/^LANG=.*/LANG=en_US.UTF-8/' /etc/locale.conf && \
    locale-gen && \
    pacman -Scc --noconfirm && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/* /tmp/* /var/tmp/*

COPY --chown=abao:abao . /home/${USER_NAME}/.dotfiles

RUN cd /home/${USER_NAME}/.dotfiles && \
    sudo pacman -Syy && \
    sudo -u abao mise run install-yay && \
    sudo -u abao mise run ${RECIPE} && \
    sudo -u abao zsh --interactive -c "echo Installing..." && \
    pacman -Scc --noconfirm && \
    sed -i '/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL$/s/^/# /' /etc/sudoers && \
    sed -i '/^# %wheel ALL=(ALL:ALL) ALL$/s/^# //' /etc/sudoers && \
    echo "${USER_NAME}:${USER_PASSWORD}" |chpasswd && \
    rm -rf /var/cache/pacman/pkg/* /var/lib/pacman/sync/* /tmp/* /var/tmp/* /home/${USER_NAME}/.cache

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
CMD ["zsh"]
