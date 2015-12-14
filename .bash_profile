
[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

# Export GTK2_RC_FILES
export GTK2_RC_FILES="/etc/gtk-2.0/gtkrc:$HOME/.gtkrc-2.0"

source ~/.shell_prompt_lucius.sh


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
