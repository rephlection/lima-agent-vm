export PATH="$HOME/.local/bin:$PATH"

alias fd=fdfind # Debian install fd-find as fdfind because of fd in fdutils

# Source all custom zsh files
if [[ -d ~/.zshrc.d ]]; then
  for file in ~/.zshrc.d/*.zsh; do
    [[ -r "$file" ]] && source "$file"
  done
fi

export PI_TELEMETRY=0
# export PI_SKIP_VERSION_CHECK=1
# export PI_OFFLINE=1

export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
export CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY=1
export DISABLE_TELEMETRY=1
export DO_NOT_TRACK=1
export DISABLE_ERROR_REPORTING=1

eval "$(starship init zsh)"
