FROM ubuntu:latest

ARG USER_NAME=abao
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

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}/.dotfiles

COPY --chown=abao:abao . /home/${USER_NAME}/.dotfiles

RUN sudo apt-get update && \
    just ${RECIPE} && \
    zsh --interactive -c "echo Installing..." && \
    sudo sed -i '$d' /etc/sudoers && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["zsh"]


