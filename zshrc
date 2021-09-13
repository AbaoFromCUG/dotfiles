# Created by newuser for 5.7.1


# Use Antigen  https://github.com/zsh-users/antigen
# Install antigen.zsh if not exist
#
ANTIGEN="$HOME/.local/bin/antigen.zsh"
if [ ! -f "$ANTIGEN" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
	[ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	URL="http://git.io/antigen"
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which curl)" ]; then
		curl -L "$URL" -o "$TMPFILE" 
	elif [ -x "$(which wget)" ]; then
		wget "$URL" -O "$TMPFILE" 
	else
		echo "ERROR: please install curl or wget before installation !!"
		exit
	fi
	if [ ! $? -eq 0 ]; then
		echo ""
		echo "ERROR: downloading antigen.zsh ($URL) failed !!"
		exit
	fi;
	echo "move $TMPFILE to $ANTIGEN"
	mv "$TMPFILE" "$ANTIGEN"
fi

# Enable 256 color to make auto-suggestions look nice
#export TERM="screen-256color"

source "$ANTIGEN"

# Initialize oh-my-zsh
antigen use oh-my-zsh

# antigen bundle 
#default bundle
antigen bundle pip
antigen bundle git
antigen bundle colorize
antigen bundle github
antigen bundle python
antigen bundle command-not-found
antigen bundle Vifon/deer
antigen bundle gruvbox

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
# enable syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting


#----------- hight light
# syntax color definition
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

typeset -A ZSH_HIGHLIGHT_STYLES

# ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none

# load local config
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh" 
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"

antigen theme robbyrussell
# antigen theme gruvbox
antigen apply
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

autoload -U deer
zle -N deer
bindkey '\ek' deer

bindkey -s '\eo' 'cd ..\n'



#export http_proxy="http://127.0.0.1:12333"
#export https_proxy="http://127.0.0.1:12333"
export all_proxy=""
#tmux 
export POWERLINE_CONFIG_COMMAND=/home/abao/.pyenv/shims/powerline-config
export POWERLINE_COMMAND=/home/abao/.pyenv/shims/powerline

function docker_ip() {
        sudo docker inspect --format '{{ .NetworkSettings.IPAddress  }}' $1
        
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export HOMEBREW_NO_AUTO_UPDATE=true

export PATH="/usr/local/opt/llvm@9/bin:$PATH"
export PATH="/usr/local/opt/llvm@9/bin:$PATH"
export PATH="/usr/local/opt/llvm@9/bin:$PATH"
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"

export CMAKE_INCLUDE_PATH=/usr/local/Cellar/liblcf/0.6.2_1/include:$CMAKE_INCLUDE_PATH
export CMAKE_INCLUDE_PATH=/usr/local/Cellar/eigen/3.3.7/include:$CMAKE_INCLUDE_PATH

alias vim=nvim
