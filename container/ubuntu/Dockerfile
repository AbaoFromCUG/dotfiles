FROM ubuntu:latest

ARG USER_NAME=abao
ARG USER_PASSWORD=password
ARG RECIPE=bootstrap-docker

RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install sudo zsh curl git locales -y && \
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin && \
    userdel ubuntu -r && \
    useradd --groups sudo --shell /usr/bin/zsh --uid 1000 -m ${USER_NAME} && \
    sed -i '$a %sudo ALL=(ALL) NOPASSWD:ALL' /etc/sudoers && \
    locale-gen en_US.UTF-8 && \
    locale-gen zh_CN.UTF-8 && \
    update-locale LANG=en_US.UTF-8 && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --chown=abao:abao . /home/${USER_NAME}/.dotfiles

RUN cd /home/${USER_NAME}/.dotfiles && \
    sudo -u abao just config-ubuntu && \
    sudo -u abao just ${RECIPE} && \
    sudo -u abao zsh --interactive -c "echo Installing..." && \
    sed -i '$d' /etc/sudoers && \
    sed -i '/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL$/s/^/# /' /etc/sudoers && \
    sed -i '/^# %wheel ALL=(ALL:ALL) ALL$/s/^# //' /etc/sudoers && \
    echo "${USER_NAME}:${USER_PASSWORD}" |chpasswd && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /home/${USER_NAME}/.cache

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
CMD ["zsh"]
