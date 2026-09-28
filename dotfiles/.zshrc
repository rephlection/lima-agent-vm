export PATH="$HOME/.local/bin:$PATH"

alias fd=fdfind # Debian install fd-find as fdfind because of fd in fdutils

# Source all custom zsh files
if [[ -d ~/.zshrc.d ]]; then
  for file in ~/.zshrc.d/*.zsh; do
    [[ -r "$file" ]] && source "$file"
  done
fi

eval "$(starship init zsh)"
