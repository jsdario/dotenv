#!/usr/bin/env zsh
# install.zsh — interactive dev environment setup
# Run from the dotenv repo root: zsh install.zsh
# Dry run (no changes):        zsh install.zsh --dry-run

set -e

DOTENV_DIR="${0:A:h}"
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

DRY_RUN=0
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=1

run() {
  # run <description> <cmd> [args…]
  local desc="$1"; shift
  if (( DRY_RUN )); then
    echo "  ${YELLOW}would run:${RESET} $*"
  else
    "$@"
  fi
}

ask() {
  # In dry-run mode always say yes so every branch is shown
  if (( DRY_RUN )); then
    printf "${BOLD}$1${RESET} ${DIM}[y/N]${RESET} ${YELLOW}(dry-run: yes)${RESET}\n"
    return 0
  fi
  printf "${BOLD}$1${RESET} ${DIM}[y/N]${RESET} "
  read -r reply
  [[ "$reply" =~ ^[Yy]$ ]]
}

step() {
  echo ""
  echo "${GREEN}▸ $1${RESET}"
}

done_msg() {
  if (( DRY_RUN )); then
    echo "  ${YELLOW}✓ (dry-run) $1${RESET}"
  else
    echo "${GREEN}  ✓ $1${RESET}"
  fi
}

skip_msg() {
  echo "${DIM}  — skipped${RESET}"
}

echo ""
echo "${BOLD}Dev environment setup${RESET}"
if (( DRY_RUN )); then
  echo "${YELLOW}DRY RUN — no changes will be made${RESET}"
else
  echo "${DIM}Each step will ask before making changes.${RESET}"
fi

# ── Oh My Zsh ──────────────────────────────────────────────────────────────
step "Oh My Zsh"
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "  Already installed."
elif ask "Install Oh My Zsh?"; then
  run "install oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  done_msg "Oh My Zsh installed"
else
  skip_msg
fi

# ── Nano as default editor ──────────────────────────────────────────────────
step "Use nano instead of vim"
if grep -q 'EDITOR=nano' "$HOME/.zshrc" 2>/dev/null; then
  echo "  Already set."
elif ask "Set nano as default \$EDITOR in ~/.zshrc?"; then
  run "append EDITOR=nano to ~/.zshrc" tee -a "$HOME/.zshrc" <<< 'export EDITOR=nano'
  done_msg "Added EDITOR=nano to ~/.zshrc"
else
  skip_msg
fi

# ── Homebrew ────────────────────────────────────────────────────────────────
step "Homebrew"
if command -v brew &>/dev/null; then
  echo "  Already installed at $(brew --prefix)."
elif ask "Install Homebrew?"; then
  run "install homebrew" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Add brew to PATH for the rest of this script
  if (( ! DRY_RUN )); then
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
  done_msg "Homebrew installed"
else
  skip_msg
fi

# ── Homebrew PATH in zshrc ───────────────────────────────────────────────────
if command -v brew &>/dev/null; then
  step "Add Homebrew to PATH in ~/.zshrc"
  if grep -q 'brew shellenv\|brew --prefix' "$HOME/.zshrc" 2>/dev/null; then
    echo "  Already present."
  elif ask "Add brew shellenv to ~/.zshrc?"; then
    run "append brew shellenv to ~/.zshrc" tee -a "$HOME/.zshrc" <<< 'eval "$($(brew --prefix)/bin/brew shellenv)"'
    done_msg "Added brew shellenv to ~/.zshrc"
  else
    skip_msg
  fi
fi

# ── Apps via mas + brew cask ─────────────────────────────────────────────────
step "Apps (stats, mas, Slack, 1Password, WhatsApp, Amphetamine)"
if ask "Install apps via Homebrew + mas?"; then
  run "brew install stats"      brew install --cask stats
  run "brew install mas"        brew install mas
  run "mas install slack"       mas lucky slack
  run "mas install 1Password"   mas lucky 1Password
  run "mas install WhatsApp"    mas lucky WhatsApp
  run "mas install Amphetamine" mas lucky Amphetamine
  done_msg "Apps installed"
else
  skip_msg
fi

# ── Zsh plugins ──────────────────────────────────────────────────────────────
step "Zsh: frequency-based cd (z)"
if [[ -f "$HOME/.oh-my-zsh/custom/plugins/z/z.sh" ]] || command -v z &>/dev/null; then
  echo "  Already available."
elif ask "Install z (frequency-based cd)?"; then
  run "brew install z" brew install z
  done_msg "z installed"
else
  skip_msg
fi

step "Zsh: syntax highlighting"
ZSH_SYNTAX="$HOME/.oh-my-zsh/zsh-syntax-highlighting"
if [[ -d "$ZSH_SYNTAX" ]]; then
  echo "  Already cloned."
elif ask "Install zsh-syntax-highlighting?"; then
  run "git clone zsh-syntax-highlighting" git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_SYNTAX"
  if ! grep -q 'zsh-syntax-highlighting.zsh' "$HOME/.zshrc" 2>/dev/null; then
    run "append source line to ~/.zshrc" tee -a "$HOME/.zshrc" <<< "source $ZSH_SYNTAX/zsh-syntax-highlighting.zsh"
  fi
  done_msg "zsh-syntax-highlighting installed"
else
  skip_msg
fi

# ── Git hooks ────────────────────────────────────────────────────────────────
step "Git hooks (no whitespace-only commits)"
CURRENT_HOOKS=$(git config --global core.hooksPath 2>/dev/null || true)
if [[ "$CURRENT_HOOKS" == "$DOTENV_DIR/hooks" ]]; then
  echo "  Already pointing to $DOTENV_DIR/hooks."
elif ask "Set global git hooksPath to $DOTENV_DIR/hooks?"; then
  run "git config core.hooksPath" git config --global core.hooksPath "$DOTENV_DIR/hooks"
  done_msg "core.hooksPath → $DOTENV_DIR/hooks"
else
  skip_msg
fi

# ── Git aliases ───────────────────────────────────────────────────────────────
step "Git aliases (ci, co, cp, st, br, lg, graph, pl, undo, amend, wt, strip-whitespace…)"
if ask "Apply git aliases to global config?"; then
  run "git alias ci"             git config --global alias.ci    "commit"
  run "git alias co"             git config --global alias.co    "checkout"
  run "git alias cp"             git config --global alias.cp    "cherry-pick"
  run "git alias st"             git config --global alias.st    "status"
  run "git alias br"             git config --global alias.br    "branch --sort=-committerdate --format='%(HEAD) %(refname:short)  %(committerdate:relative)'"
  run "git alias lg"             git config --global alias.lg    "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)%Creset' --abbrev-commit"
  run "git alias graph"          git config --global alias.graph "log --graph --all '--pretty=format:%Cred%h%Creset %ad | [%C(bold blue)%an%Creset] %Cgreen%d%Creset %s' --date=iso"
  run "git alias rem"            git config --global alias.rem   "remote"
  run "git alias ls"             git config --global alias.ls    "rem -v"
  run "git alias pl"             git config --global alias.pl    "pull --rebase"
  run "git alias sm"             git config --global alias.sm    "submodule"
  run "git alias undo"           git config --global alias.undo  "reset --soft HEAD^"
  run "git alias amend"          git config --global alias.amend "commit -a --amend --no-edit"
  run "git alias conflicts"      git config --global alias.conflicts "!git ls-files -u | cut -f 2 | sort -u"
  run "git alias compare"        git config --global alias.compare  "!git diff master...\"$(git symbolic-ref --short HEAD)\""
  run "git alias strip-whitespace" git config --global alias.strip-whitespace \
    '!git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero - && git restore .'
  run "git alias stale"          git config --global alias.stale \
    "!git for-each-ref --sort=committerdate --format='%(refname:short)  %(committerdate:relative)' refs/heads/ | awk -v d=\"\$(date -v-1m +%s)\" '{cmd=\"git log -1 --format=%ct \"\$1\"\"; cmd | getline t; close(cmd); if(t < d) print \$0}'"
  run "git alias drop"           git config --global alias.drop \
    "!git for-each-ref --sort=committerdate --format='%(refname:short)' refs/heads/ | awk -v d=\"\$(date -v-1m +%s)\" '{cmd=\"git log -1 --format=%ct \"\$1\"\"; cmd | getline t; close(cmd); if(t < d) print \$1}' | xargs -r -n 1 git branch -d"
  run "git alias wt"             git config --global alias.wt \
    '!f() { repo=$(basename "$(git rev-parse --show-toplevel)"); git worktree add "../${repo}-${@: -1}" "$@"; }; f'
  run "git core.editor nano"     git config --global core.editor nano
  run "git push.default current" git config --global push.default current
  run "git autoSetupMerge"       git config --global branch.autoSetupMerge always
  run "git merge.ff"             git config --global merge.ff true
  done_msg "Git aliases applied"
else
  skip_msg
fi

# ── diff-so-fancy ─────────────────────────────────────────────────────────────
step "Fancy diffs (diff-so-fancy)"
if git config --global core.pager | grep -q 'diff-so-fancy' 2>/dev/null; then
  echo "  Already configured."
elif ask "Install diff-so-fancy and set as git pager?"; then
  run "npm install diff-so-fancy" npm i -g diff-so-fancy
  run "git config core.pager"     git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
  done_msg "diff-so-fancy configured"
else
  skip_msg
fi

# ── ccat (fancy cat) ──────────────────────────────────────────────────────────
step "Fancy cat (ccat via pygments)"
if command -v ccat &>/dev/null || command -v pygmentize &>/dev/null; then
  echo "  pygmentize already available."
elif ask "Install pygments and add ccat alias to ~/.zshrc?"; then
  run "pip3 install pygments" pip3 install pygments
  if ! grep -q 'ccat' "$HOME/.zshrc" 2>/dev/null; then
    run "append ccat alias to ~/.zshrc" tee -a "$HOME/.zshrc" <<< "alias ccat='pygmentize -f terminal256 -O style=native -g'"
  fi
  done_msg "ccat alias added"
else
  skip_msg
fi

# ── The Silver Searcher ───────────────────────────────────────────────────────
step "The Silver Searcher (ag)"
if command -v ag &>/dev/null; then
  echo "  Already installed."
elif ask "Install the_silver_searcher?"; then
  run "brew install the_silver_searcher" brew install the_silver_searcher
  done_msg "ag installed"
else
  skip_msg
fi

# ── Sublime Text + Merge ──────────────────────────────────────────────────────
step "Sublime Text + Sublime Merge"
if ask "Install Sublime Text and Sublime Merge?"; then
  run "brew install sublime-text sublime-merge" brew install --cask sublime-text sublime-merge
  run "mkdir ~/bin" mkdir -p "$HOME/bin"
  if [[ ! -L "$HOME/bin/smerge" ]]; then
    run "symlink smerge" ln -s "/Applications/Sublime Merge.app/Contents/SharedSupport/bin/smerge" "$HOME/bin/smerge"
    done_msg "smerge symlinked to ~/bin/smerge"
  fi
  done_msg "Sublime apps installed"
else
  skip_msg
fi

# ── tmux config ───────────────────────────────────────────────────────────────
step "tmux configuration (mouse support)"
if [[ -L "$HOME/.tmux.conf" ]] && [[ "$(readlink "$HOME/.tmux.conf")" == "$DOTENV_DIR/tmux.conf" ]]; then
  echo "  Already symlinked."
elif ask "Symlink tmux.conf to ~/.tmux.conf?"; then
  run "symlink tmux.conf" ln -sf "$DOTENV_DIR/tmux.conf" "$HOME/.tmux.conf"
  done_msg "~/.tmux.conf → $DOTENV_DIR/tmux.conf"
else
  skip_msg
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "${BOLD}${GREEN}All done.${RESET} Restart your shell (or run: source ~/.zshrc) to pick up changes."
echo ""
