# Forked from oh my zshessembeh-zsh
# Thanks to @essembeh
# My custom theme:
#   - single line
#   - quite simple by default: user@host:$PWD
#   - green for local shell as non root
#   - red for ssh shell as non root
#   - magenta for root sessions
#   - prefix with remote address for ssh shells
#   - prefix to detect docker containers or chroot
#   - git plugin to display current branch and status

# git plugin
ZSH_THEME_GIT_PROMPT_PREFIX="%B%{$FG[111]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}%b"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"

function zsh_poz_gitstatus {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	if [[ -n $GIT_STATUS ]]; then
		GIT_STATUS=" $GIT_STATUS"
	fi
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# by default, use green for user@host and no prefix
local ZSH_POZ_COLOR="083"
local ZSH_POZ_PREFIX=""
if [[ -n "$SSH_CONNECTION" ]]; then
	# display the source address if connected via ssh
	ZSH_POZ_PREFIX="%{$fg[yellow]%}[$(echo $SSH_CONNECTION | awk '{print $1}')]%{$reset_color%} "
	# use red color to highlight a remote connection
	ZSH_POZ_COLOR="196"
elif [[ -r /etc/debian_chroot ]]; then
	# prefix prompt in case of chroot
	ZSH_POZ_PREFIX="%{$fg[yellow]%}[chroot:$(cat /etc/debian_chroot)]%{$reset_color%} "
elif [[ -r /.dockerenv ]]; then
	# also prefix prompt inside a docker container
	ZSH_POZ_PREFIX="%{$fg[yellow]%}[docker]%{$reset_color%} "
fi
if [[ $UID = 0 ]]; then
	# always use magenta for root sessions, even in ssh
	ZSH_POZ_COLOR="199"
fi
PROMPT='%F{243}%D{%H:%M:%S}%f %B${ZSH_POZ_PREFIX}%{$FG[$ZSH_POZ_COLOR]%}%n@%M%{$reset_color%}%b:%{%B$fg[yellow]%}%(5~|%-1~/…/%3~|%4~)%{$reset_color%b%} $(zsh_poz_gitstatus)%(!.#.$) '
RPROMPT="%(?..%{$fg[red]%}%?%{$reset_color%})"
