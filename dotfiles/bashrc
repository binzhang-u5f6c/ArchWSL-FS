#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias
alias ls='ls --color=auto'
alias sl='ls -alh'
alias grep='grep --color'
alias jupyterlab='jupyter-lab --no-browser'

# prompt
function nonzero_return {
    RETVAL=$?
    [ $RETVAL -ne 0 ] && echo " [$RETVAL]"
}

PS1='\[\033[34m\]\W\[\033[31m\]$(nonzero_return)\[\033[0m\] \$ '

# local PATH
if ! [[ "$PATH" =~ "$HOME/.local/bin:" ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi
