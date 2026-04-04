# --- History ---
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd extendedglob
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history
bindkey -v

# --- Completion ---
zstyle :compinstall filename '$HOME/.zshrc'
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
autoload -Uz compinit
compinit

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/go/bin"

# --- Colors ---
autoload -Uz colors && colors

# Color aliases
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'

# --- eza (reemplazo moderno de ls) ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first --git'
alias la='eza -la --icons --group-directories-first --git'
alias l='eza -l --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'

# --- bat (reemplazo de cat) ---
alias cat='bat --style=auto'
alias catp='bat --style=plain'

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export BAT_THEME="Catppuccin Mocha"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# --- Plugins ---
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- fzf ---
source /usr/share/fzf/key-bindings.zsh 2>/dev/null
source /usr/share/fzf/completion.zsh 2>/dev/null
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f38ba8,fg+:#cdd6f4,bg+:#313244,hl+:#f38ba8,info:#cba6f7,prompt:#cba6f7,pointer:#f5e0dc,marker:#b4befe,spinner:#f5e0dc,header:#f38ba8'
export FZF_CTRL_R_OPTS='--preview "echo {}" --preview-window=down:3:wrap'

# --- Git commit con autocompletado de mensajes previos ---
gcm() {
  if [ -z "$1" ]; then
    local msg=$(git log --oneline --no-merges -50 --format="%s" 2>/dev/null | fzf --header="Select previous commit message (or ESC to type new)" --preview-window=hidden)
    if [ -n "$msg" ]; then
      git commit -m "$msg"
    else
      echo "Commit cancelled."
    fi
  else
    git commit -m "$*"
  fi
}

# --- Git commit auto (genera mensaje segun los cambios) ---
gca() {
  local staged=$(git diff --cached --name-status 2>/dev/null)
  if [ -z "$staged" ]; then
    echo "No hay cambios en staging. Usa 'git add' primero."
    return 1
  fi

  local added=$(echo "$staged" | grep '^A' | wc -l)
  local modified=$(echo "$staged" | grep '^M' | wc -l)
  local deleted=$(echo "$staged" | grep '^D' | wc -l)
  local renamed=$(echo "$staged" | grep '^R' | wc -l)
  local total=$((added + modified + deleted + renamed))

  # Detect main directory/scope
  local scope=$(echo "$staged" | awk '{print $2}' | head -1 | cut -d'/' -f1)

  # If all files in same dir, use it as scope
  local dirs=$(echo "$staged" | awk '{print $2}' | cut -d'/' -f1 | sort -u | wc -l)
  if [ "$dirs" -gt 1 ]; then
    scope="general"
  fi

  # Detect type of change
  local type=""
  if [ "$added" -gt 0 ] && [ "$modified" -eq 0 ] && [ "$deleted" -eq 0 ]; then
    type="add"
  elif [ "$deleted" -gt 0 ] && [ "$added" -eq 0 ] && [ "$modified" -eq 0 ]; then
    type="remove"
  elif [ "$modified" -gt 0 ] && [ "$added" -eq 0 ] && [ "$deleted" -eq 0 ]; then
    type="update"
  else
    type="update"
  fi

  # Build file list summary
  local files=$(echo "$staged" | awk '{print $2}' | xargs -I{} basename {} | sort -u | head -3 | tr '\n' ', ' | sed 's/,$//' | sed 's/,/, /g')
  local extra=""
  if [ "$total" -gt 3 ]; then
    extra=" (+$((total - 3)) more)"
  fi

  local msg="${type}(${scope}): ${files}${extra}"

  echo "\033[1;36mCommit message:\033[0m $msg"
  echo ""
  echo "\033[1;33mStaged changes:\033[0m"
  echo "$staged"
  echo ""
  read -q "confirm?Commit? [y/N] "
  echo ""

  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    git commit -m "$msg"
  else
    echo "Cancelled. Message was: $msg"
    echo "Tip: usa 'gcm \"tu mensaje\"' para escribir uno custom."
  fi
}

# --- zoxide (cd inteligente) ---
eval "$(zoxide init zsh)"
alias cd='z'

# --- Starship prompt ---
eval "$(starship init zsh)"

# --- fastfetch al abrir terminal ---
fastfetch
