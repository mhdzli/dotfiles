##!/usr/bin/env bash
# ~/.bashrc
#
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# stty -ixon # Disable ctrl-s and ctrl-q.

shopt -s autocd #Allows you to cd into directory merely by typing the directory name.

HISTSIZE= HISTFILESIZE= # Infinite history.

export PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
#PS1='[\u@\h \W]\$ '

alias ls='ls --color=auto -lah'
alias vim='nvim'
alias shdn='shutdown now'
alias vifm='sh $HOME/.config/vifm/scripts/vifmrun'
alias tor='sh -x ~/Downloads/Software/tor-browser_en-US/Browser/start-tor-browser --detach'
alias aria2c='aria2c -c -x 16 -s 16 -k 1M -d ~/Downloads'

