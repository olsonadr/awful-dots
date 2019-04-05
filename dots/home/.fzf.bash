# Setup fzf
# ---------
if [[ ! "$PATH" == */home/olsonadr/.fzf/bin* ]]; then
  export PATH="$PATH:/home/olsonadr/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/olsonadr/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/usr/share/fzf/shell/key-bindings.bash"

