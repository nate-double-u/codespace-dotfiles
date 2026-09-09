#!/usr/bin/env bash
# Codespaces dotfiles installer. Runs automatically on codespace creation
# when GitHub Settings -> Codespaces -> "Automatically install dotfiles"
# points at this repo.
set -euo pipefail
cd "$(dirname "$0")"

log() { printf '==> %s\n' "$*"; }

log "Installing nvim, tmux, and shell configs"
mkdir -p "$HOME/.config/nvim" "$HOME/.config/zsh" "$HOME/.tmux"
cp -R .config/nvim/. "$HOME/.config/nvim/"
cp -f .config/zsh/portable.zsh "$HOME/.config/zsh/portable.zsh"
cp -f .tmux/tmux.conf "$HOME/.tmux/tmux.conf"
ln -sf .tmux/tmux.conf "$HOME/.tmux.conf"

log "Wiring portable.zsh into zsh and bash"
snippet='[ -f "$HOME/.config/zsh/portable.zsh" ] && . "$HOME/.config/zsh/portable.zsh"'
for rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
  touch "$rc"
  grep -qs 'config/zsh/portable.zsh' "$rc" || printf '\n%s\n' "$snippet" >>"$rc"
done

if ! command -v nvim >/dev/null 2>&1; then
  log "Installing neovim"
  if command -v brew >/dev/null 2>&1; then
    brew install neovim
  elif command -v apt-get >/dev/null 2>&1; then
    SUDO=sudo
    if [ "$(id -u)" = 0 ] || ! command -v sudo >/dev/null 2>&1; then SUDO=; fi
    $SUDO apt-get update -y -qq
    $SUDO apt-get install -y -qq neovim
  else
    log "WARNING: no brew or apt-get; install neovim manually"
  fi
fi

log "Done. nvim and tmux install their own plugins on first launch."
