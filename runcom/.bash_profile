# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# OS

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

READLINK=$(which greadlink || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
    SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
    DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
    DOTFILES_DIR="$HOME/.dotfiles"
else
    echo "Unable to find dotfiles, exiting."
    return # `exit 1` would quit the shell itself
fi

# Finally we can source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,env,prompt,alias}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done

[ -f "$HOME/.bash_profile.local" ] && . "$HOME/.bash_profile.local"

# Set LSCOLORS

if type dircolors >/dev/null 2>&1; then
   eval "$(dircolors "$DOTFILES_DIR"/system/.dir_colors)"
fi

# Clean up

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE

# Export

export DOTFILES_DIR
