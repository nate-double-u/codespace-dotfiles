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
  grep -qxF -- "$snippet" "$rc" || printf '\n%s\n' "$snippet" >>"$rc"
done

SUDO=sudo
if [ "$(id -u)" = 0 ] || ! command -v sudo >/dev/null 2>&1; then SUDO=; fi
APT_UPDATED=
apt_install() {
  if [ -z "$APT_UPDATED" ]; then $SUDO apt-get update -y -qq; APT_UPDATED=1; fi
  $SUDO apt-get install -y -qq "$@"
}

if ! command -v tmux >/dev/null 2>&1; then
  log "Installing tmux"
  if command -v brew >/dev/null 2>&1; then
    brew install tmux
  elif command -v apt-get >/dev/null 2>&1; then
    apt_install tmux
  else
    log "WARNING: no brew or apt-get; install tmux manually"
  fi
fi

if ! command -v nvim >/dev/null 2>&1; then
  log "Installing neovim"
  case "$(uname -s)-$(uname -m)" in
    Linux-x86_64)  nvim_tar=nvim-linux-x86_64.tar.gz ;;
    Linux-aarch64) nvim_tar=nvim-linux-arm64.tar.gz ;;
    *)             nvim_tar= ;;
  esac
  if [ -n "$nvim_tar" ] && curl -fsSL -o /tmp/nvim.tar.gz \
      "https://github.com/neovim/neovim/releases/latest/download/$nvim_tar"; then
    $SUDO tar -C /opt -xzf /tmp/nvim.tar.gz
    $SUDO ln -sf "/opt/${nvim_tar%.tar.gz}/bin/nvim" /usr/local/bin/nvim
    rm -f /tmp/nvim.tar.gz
  elif command -v brew >/dev/null 2>&1; then
    brew install neovim
  elif command -v apt-get >/dev/null 2>&1; then
    apt_install neovim
  else
    log "WARNING: no brew or apt-get; install neovim manually"
  fi
fi

log "Done. nvim and tmux install their own plugins on first launch."
