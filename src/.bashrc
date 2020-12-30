### My bashrc
### If not running interactively, don't do anything
[[ $- == *i* ]] || return

# stty -ixon # Disable ctrl-s and ctrl-q.

### cd into directory merely by typing the directory name. ###
shopt -s autocd 
HISTSIZE= HISTFILESIZE= # Infinite history.

### Enable vi mode ###
set -o vi

### Set vim as manpager ###
export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist noma' -\""
# export MANPAGER="/bin/sh -c \"col -b | vim --not-a-term -c 'set ft=man ts=8 nomod nolist noma' -\""

[ -f "$HOME/.config/shell/aliasrc" ] && source $HOME/.config/shell/bash_git_prompts
[ -f "$HOME/.config/broot/launcher/bash/br" ] && source $HOME/.config/broot/launcher/bash/br
[ -f "$HOME/.config/shell/aliasrc" ] && source $HOME/.config/shell/aliasrc
