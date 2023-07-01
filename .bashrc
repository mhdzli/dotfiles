### My bashrc

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

### If not running interactively, don't do anything
[[ $- == *i* ]] || return

# stty -ixon # Disable ctrl-s and ctrl-q.

### cd into directory merely by typing the directory name. ###
shopt -s autocd 
HISTSIZE=HISTFILESIZE= # Infinite history.
export HISTFILE="${XDG_DATA_HOME:-$HOME/.data}/bash/history"

### Enable vi mode ###
set -o vi

# navi widget
navi -h >/dev/null 2>&1 && eval "$(navi widget bash)"

# McFly - fly through your shell history
mcfly -h >/dev/null 2>&1 && eval "$(mcfly init bash)"

# Add zoxide to zsh
zoxide -h >/dev/null 2>&1 && eval "$(zoxide init bash)"

# fuck alias
thefuck -h >/dev/null 2>&1 && eval "$(thefuck --alias)"

[[ -f "$config_dir/shell/bash_git_prompts" ]] && source "$config_dir/shell/bash_git_prompts"
[[ -f "$config_dir/broot/launcher/bash/br" ]] && source "$config_dir/broot/launcher/bash/br"
[[ -f "$config_dir/shell/aliasrc" ]] && source "$config_dir/shell/aliasrc"
