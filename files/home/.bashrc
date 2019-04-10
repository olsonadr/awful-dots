# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
# export PS1="\[\033[38;5;214m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput sgr0)\]\[\033[38;5;215m\]\h\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;15m\]:\[$(tput sgr0)\][\[$(tput sgr0)\]\[\033[38;5;45m\]\W\[$(tput sgr0)\]\[\033[38;5;15m\]]\\$ \[$(tput sgr0)\]\[\033[38;5;99m\] \[$(tput sgr0)\]"

export PS1="\[\e[1;03;36m\]\u@\h\[\e[0m\]\[\e[1;03;31m\][\W]\[\e[0m\]\[\e[1;03m\]\$\[\e[0m\] "

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

export PATH="/home/olsonadr/.local/bin:/home/olsonadr/bin:/home/olsonadr/.local/bin:/home/olsonadr/bin:/usr/share/Modules/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/home/olsonadr/.vimpkg/bin"

unset command_not_found_handle

export FZF_DEFAULT_OPTS='--height 50% --layout=reverse --border'

function fcd () {
    cd $(dirname $(fzf))
}

alias ssh-flip="ssh olsonn2@flip.engr.oregonstate.edu"
alias ssh-access="ssh olsonn2@access.engr.oregonstate.edu"
alias sftp-flip="sftp olsonn2@flip.engr.oregonstate.edu"
alias sftp-access="sftp olsonn2@access.engr.oregonstate.edu"
