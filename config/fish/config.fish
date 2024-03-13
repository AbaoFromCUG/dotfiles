

set -g fish_greeting

fish_config theme choose tokyonight_night

if status is-interactive && ! functions --query fisher
    set -xU fisher_path ~/.local/share/fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher update
    tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='One line' --prompt_spacing=Compact --icons='Few icons' --transient=No
    
    set -U tide_right_prompt_frame_enabled true
    set -U tide_right_prompt_items status pyenv nvm
    set -U tide_character_icon 󰜎

end 

if ! type -q pyenv && test -d ~/.pyenv
    set -Ux PYENV_ROOT $HOME/.pyenv
    fish_add_path $PYENV_ROOT/bin
end


zoxide init fish |source
pyenv init - | source
