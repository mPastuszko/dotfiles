# SSH-only stuff. Abort if not connected via SSH.
[[ "$SSH_TTY" ]] || return 1

# Attach to existing tmux session or start a new one
[ -z "$TMUX" ] && tmux attach || tmux
