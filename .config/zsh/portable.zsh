# Portable shell config for codespaces and other Linux boxes.
# Sourced by both bash and zsh. No secrets in this file (public repo).

export EDITOR=nvim

# muscle memory
if command -v nvim >/dev/null 2>&1; then
  alias vi=nvim
  alias vim=nvim
fi

# t [name]: attach to or create a named tmux session
t() {
  local s="${1:-}"
  if [ -z "$s" ] && command -v fzf >/dev/null 2>&1; then
    s=$(tmux ls -F '#S' 2>/dev/null | fzf --prompt='tmux session> ' --print-query | tail -1)
  fi
  if [ -z "$s" ]; then
    tmux ls 2>/dev/null || echo "usage: t <session-name>"
    return 0
  fi
  if [ -n "${TMUX:-}" ]; then
    tmux has-session -t "=$s" 2>/dev/null || tmux new-session -d -s "$s"
    tmux switch-client -t "=$s"
  else
    tmux new-session -A -s "$s"
  fi
}
