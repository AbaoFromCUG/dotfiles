

set -g fish_greeting

fish_config theme choose "ayu Dark"

if test -d ~/.pyenv
    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
end


fish_add_path ~/.local/bin

zoxide init fish |source
pyenv init - | source
