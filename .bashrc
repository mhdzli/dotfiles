##!/usr/bin/env bash
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# stty -ixon # Disable ctrl-s and ctrl-q.

shopt -s autocd #Allows you to cd into directory merely by typing the directory name.

HISTSIZE= HISTFILESIZE= # Infinite history.

export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput sgr0)\]\[$(tput setaf 7)\]   \[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 2)\]\\$ \[$(tput sgr0)\]"
#PS1='[\u@\h \W]\$ '
if [ -n "$RANGER_LEVEL" ]; then export PS1="[ranger]$PS1"; fi
alias ls='ls -a --color=auto'
#alias vim='nvim'
#alias shdn='shutdown now'
# alias vifm='sh $HOME/.config/vifm/scripts/vifmrun'
alias tor='sh -x /home/mzeinali/Downloads/Software/tor-browser_en-US/Browser/start-tor-browser --detach'
alias a2c='aria2c -c -x 16 -s 16 -k 1M -d ~/Downloads'
alias imv='imv -b 1D2330 -d'

