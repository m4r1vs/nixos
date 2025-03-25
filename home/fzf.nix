{
  enable = true;
  enableZshIntegration = false; # manually enable in zsh init
  defaultOptions = [
    "--bind ctrl-e:preview-down,ctrl-y:preview-up,alt-k:up,alt-j:down"
    "--preview-window=right,65%"
  ];
}
