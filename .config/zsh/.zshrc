# My zshrc

cache_dir=${XDG_CACHE_HOME:-$HOME/.cache}
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
[[ -r "$cache_dir/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "$cache_dir/p10k-instant-prompt-${(%):-%n}.zsh"


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.

# History in cache directory:
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.cache/zsh/history

# Load aliases and shortcuts if existent.
[[ -f "$config_dir/shell/aliasrc" ]] && source "$config_dir/shell/aliasrc"

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

# Use beam shape cursor for each new prompt; Called when executing a command to show the window title in terminal
preexec() {
    echo -ne '\e[5 q'; print -Pn "\e]0;${(q)1}\e\\"
} 

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line

# Emacs style
zle -N edit-command-line
bindkey '^x^x' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

### prompts

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ -f "$config_dir/zsh/.p10k.zsh" ]] && source "$config_dir/zsh/.p10k.zsh"
[[ -f "$config_dir/zsh/powerlevel10k/powerlevel10k.zsh-theme" ]] && source "$config_dir/zsh/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme" ]] && source "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme"

# To customize spaceship prompt, edit ~/.config/zsh/.spaceship.zsh.
# [[ -f "$config_dir/zsh/.spaceship.zsh" ]] && source "$config_dir/zsh/.spaceship.zsh"

# Navi cheat sheet widget
navi -h >/dev/null 2>&1 && eval "$(navi widget zsh)"

# McFly history tool
mcfly  -h >/dev/null 2>&1 && eval "$(mcfly init zsh)"
# bindkey '^R' history-incremental-search-backward
# bindkey '^F' history-incremental-search-forward

# Add zoxide to zsh
zoxide -h >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# fuck alias
thefuck -h >/dev/null 2>&1 && eval "$(thefuck --alias)"

[[ -f "$config_dir/broot/launcher/bash/br" ]] && source "$config_dir/broot/launcher/bash/br"  

# Load zsh-autosuggestions
[[ -f "$config_dir/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$config_dir/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Load syntax highlighting; should be last.
[[ -f "$config_dir/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$config_dir/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null
[[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null

# Github-cli completion
[[ -f "$config_dir/zsh/gh-cmp.zsh" ]] && source "$config_dir/zsh/gh-cmp.zsh"
