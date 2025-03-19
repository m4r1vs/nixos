pkgs:
# zsh
''
zvm_after_init_commands+=(eval "$(${pkgs.fzf}/bin/fzf --zsh)")
zoxide_jump() {
  if zi; then
    zle push-line
    zle accept-line
  fi
  zle redisplay
}
zle -N zoxide_jump
bindkey -M 'viins' '^Z' zoxide_jump
''
