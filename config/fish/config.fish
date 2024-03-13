
set --export NVM_NODEJS_ORG_MIRROR https://mirrors.ustc.edu.cn/node/

set --global tide_right_prompt_items python node

if status is-interactive && ! functions --query fisher
    set -xU fisher_path ~/.local/share/fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher update
    tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='One line' --prompt_spacing=Compact --icons='Few icons' --transient=No
end 

if ! type -q pyenv && test -d ~/.pyenv
    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
end


zoxide init fish |source
pyenv init - | source

