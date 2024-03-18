 if set --query fisher_path
    set fish_function_path $fish_function_path[1] $fisher_path/functions $fish_function_path[2..-1]
    set fish_complete_path $fish_complete_path[1] $fisher_path/completions $fish_complete_path[2..-1]

    for file in $fisher_path/conf.d/*.fish
        source $file
    end
end

if status is-interactive && ! functions --query fisher
    set -xU fisher_path ~/.local/share/fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
    fisher update
    tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='One line' --prompt_spacing=Compact --icons='Few icons' --transient=No
    
    set -U tide_right_prompt_frame_enabled true
    set -U tide_right_prompt_items status pyenv nvm

    set -U tide_character_icon 󰜎

    set -U tide_pyenv_icon $tide_python_icon
    set -U tide_pyenv_color $tide_python_color
    set -U tide_pyenv_bg_color $tide_python_bg_color

    set -U tide_nvm_icon $tide_node_icon
    set -U tide_nvm_color $tide_node_color
    set -U tide_nvm_bg_color $tide_node_bg_color
end 
