# My bashrc
# If not running interactively, don't do anything
[[ $- == *i* ]] || return

# stty -ixon # Disable ctrl-s and ctrl-q.

shopt -s autocd #Allows you to cd into directory merely by typing the directory name.
HISTSIZE= HISTFILESIZE= # Infinite history.

# PS1='[\u@\h \W]\$ '
# PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput sgr0)\]\[$(tput setaf 7)\]   \[$(tput bold)\]\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 2)\]\\$ \[$(tput sgr0)\]"
PROMPT_PARSER(){
#	printf -v X "%.3d" $?
printf -v X "  %.3d " $? &>/dev/null
#	Dir=${PWD##*/}
#	[ "${PWD%/*}" == "/home" ] && Dir="~"
	BRed='\033[1;31m'
	White='\033[2;37m'
	BPurple='\033[1;35m'
	BYellow='\033[1;33m'
	Bgreen='\033[1;32m'
	BBlue='\033[1;34m'
	Reset='\033[0m'


	if git rev-parse --is-inside-work-tree &> /dev/null; then
		GI[0]='≎' # Clean.
		GI[1]='≍' # Uncommitted changes.
		GI[2]='≭' # Unstaged changes.
		GI[3]='≺' # New file(s).
		GI[4]='⊀' # Removed file(s).
		GI[5]='≔' # Initial commit.
		GI[6]='∾' # Branch is ahead.
		GI[7]='⮂' # Fix conflicts.
		GI[8]='!' # Unknown (ERROR).

		Status=`git status 2> /dev/null`
		Top=`git rev-parse --show-toplevel`
		printf -v Desc "${BRed}∷  ${White}Looking under the hood..."

		if [ -n "$Top" ]; then
			# Get the current branch name.
			IFS='/' read -a A < "$Top/.git/HEAD"
			GB=${A[${#A[@]}-1]}
		fi

		# While loops in special order:
		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}" == 'Initialcommit' ]; then
				Desc="${BRed}${GI[5]}  ${White}Branch '${GB:-?}' has no commits, yet."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}${Z[2]}" == '(fixconflictsand' ]; then
				Desc="${BRed}${GI[7]}  ${White}Branch '${GB:-?}' has conflict(s)."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}${Z[2]}" == 'nothingtocommit,' ]; then
				TTLCommits=`git rev-list --count HEAD`

				Desc="${BRed}${GI[0]}  ${White}Branch '${GB:-?}' is $TTLCommits commit(s) clean."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}${Z[3]}" == 'Yourbranchahead' ]; then
				Desc="${BRed}${GI[6]}  ${White}Branch '${GB:-?}' leads by ${Z[7]} commit(s)."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}" == 'Untrackedfiles:' ]; then
				#TODO: Sloppy method needs improving.
				declare -i NFTTL=0
				while read -a LINE; do
					[ "${LINE[0]}" == '??' ] && NFTTL+=1
				done <<< "$(git status --short)"

				Desc="${BRed}${GI[3]}  ${White}Branch '${GB:-?}' has $NFTTL new file(s)."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}" == 'modified:' ]; then
				readarray Buffer <<< "$(git --no-pager diff --name-only)"

				Desc="${BRed}${GI[2]}  ${White}Branch '${GB:-?}' has ${#Buffer[@]} modified file(s)."
				break
			fi
		done <<< "$Status"

		while read -ra Z; do
			if [ "${Z[0]}${Z[1]}${Z[2]}${Z[3]}" == 'Changestobecommitted:' ]; then
				Desc="${BRed}${GI[1]}  ${White}Branch '${GB:-?}' has changes to commit."
				break
			fi
		done <<< "$Status"
		# End of specially-ordered while loops.
	
	else
		printf -v Desc "${BRed}☡  ${White} Sleepy git..."
	fi
		PS1="${BYellow}╭──╼\u${Reset}${X}${BBlue}\h╾──☉ ${Reset}${Desc}\n${BPurple}╰─☉ \W${Bgreen}\\$ ${Reset}"
}

PROMPT_COMMAND='PROMPT_PARSER'

## Change the prompt inside ranger
# if [ -n "$RANGER_LEVEL" ]; then export PS1="[ranger]$PS1"; fi

### ENABLE VI MODE ###
set -o vi

### SET VIM AS MANPAGER ###
export MANPAGER="/bin/sh -c \"col -b | vim --not-a-term -c 'set ft=man ts=8 nomod nolist noma' -\""

# Replace "ls" with "exa"
#alias ls='ls -a --color=auto'
alias ls='exa -al --icons --color=always --group-directories-first' # my preferred listing
alias la='exa -a --icons --color=always --group-directories-first' # all files and dirs
alias ll='exa -l --icons --color=always --group-directories-first' # long format
alias lt='exa -aT --icons --color=always --group-directories-first' # tree listing
alias lsd='lsd -hA --group-dirs first'
alias lst='lsd -A --group-dirs first --tree'
alias du='du -ahd 1'
alias ds='dust -d 1'

# Replace cat with bat
alias cat='bat'
alias cata='bat -A'


# broot
alias bl='br -dhp'
alias bs='br --sizes'
alias v='nvim'
alias shdn='shutdown now'

# alias vifm='sh $HOME/.config/vifm/scripts/vifmrun'
alias tor='sh -x /home/mzeinali/Downloads/Software/tor-browser_en-US/Browser/start-tor-browser --detach'

# adding flags
alias cp="cp -i" # confirm before overwriting something
alias mv="mv -i" # confirm before overwriting something
alias rm="rm -i" # confirm before overwriting something

alias df='df -h' # human-readable sizes
alias free='free -m' # show sizes in MB
alias lynx='lynx -cfg=~/.lynx/lynx.cfg -lss=~/.lynx/lynx.lss -vikeys'
alias a2c='aria2c -c -x 16 -s 16 -k 1M -d ~/Downloads'
alias imv='imv -b 1D2330'
alias ts='tabbed surf -pe'

source /home/mzeinali/.config/broot/launcher/bash/br
