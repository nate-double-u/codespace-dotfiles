# codespace-dotfiles

Dev-focused dotfiles for GitHub Codespaces. Public repo: no secrets, ever.

Enable: GitHub Settings -> Codespaces -> "Automatically install dotfiles",
pick this repo. New codespaces then run `setup.sh`, which installs:

- nvim config: installs vim-plug and plugins itself on first launch
  (needs git, curl; Copilot needs node)
- tmux config: installs TPM and plugins itself on first server start
- `t <name>` helper (zsh and bash): attach or create a tmux session;
  bare `t` lists or fuzzy-picks
- neovim (current release tarball, else brew/apt) and tmux (brew/apt)
  if the image lacks them

## Notes

- tmux prefix is `C-a`. Reload config: `C-a C-r`. Plugin install: `C-a I`.
- Clipboard works over SSH via OSC52 (`set-clipboard on`).
- Best used with iTerm2 control mode from the host:
  `gh codespace ssh -- -t "tmux -CC new -A -s <task>"`.
- Configs are trimmed, portable copies from a private dotfiles repo;
  host-only bits (notes/wiki stack, mac settings) stay out.
- vi and vim are aliased to nvim.
