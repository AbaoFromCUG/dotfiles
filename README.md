# dotfiles

My dotfiles for Neovim, zsh,...  optimized for ArchLinux and WSL. Managed with [justfile](https://just.systems/).

![screenshot](./screenshot.png)

## QuickStart

* For `local` user
    ```bash
    # archlinux user
    just install-yay
    just config-dev

    # or ubuntu user
    just config-ubuntu
    just config-dev
    ```

* For `docker/podman` user
    ```bash
    # archlinux container
    podman run -it --rm --name abao-archlinux abaozhang/archlinux:latest 
    
    # or ubuntu container
    
    podman run -it --rm --name abao-ubuntu abaozhang/ubuntu:latest 
    ```

## Desktop Environment

* [Hyprland](https://hyprland.org/) a dynamic tiling Wayland compositor

* System bar via [waybar](https://github.com/Alexays/Waybar), consist of systray, time and control componnets

* [Wofi](https://hg.sr.ht/~scoopta/wofi), a launcher for wayland

* [Pipewire](https://wiki.archlinux.org/title/PipeWire) for multimedia framework, support pulseaudio/JACK/ALSA-based applications

* Fcitx5, a input method framework

## Terminal

* I use [Kitty](https://sw.kovidgoyal.net/kitty/), but [Tmux](https://github.com/tmux/tmux) as multiplexer

* [Zsh](https://www.zsh.org/) + [powerlevel10k](https://github.com/romkatv/powerlevel10k) as my shell

* Neovim on its [latest release](https://github.com/neovim/neovim/commits/master)
