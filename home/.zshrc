eval "$(starship init zsh)"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# NixOS rebuild shortcuts
alias nix-test='sudo nixos-rebuild dry-build -I nixos-config="$HOME/nixos/configuration.nix"'
alias nix-switch='sudo nixos-rebuild switch -I nixos-config="$HOME/nixos/configuration.nix"'
