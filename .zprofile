function source_if_exists() { [[ -s $1 ]] && source $1 }

# Set PATH, MANPATH, etc., for Homebrew.
eval "$(/opt/homebrew/bin/brew shellenv)"

source_if_exists "$HOME/.zshrc"
