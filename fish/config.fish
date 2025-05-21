if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
starship preset catppuccin-powerline -o ~/.config/starship.toml

set -g fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim
set fish_greeting

# aliases:

alias ls="ls -a --color=auto"
alias mdrives="lua ~/.config/scripts/mount.lua"

zoxide init --cmd cd fish | source


# Created by `pipx` on 2025-05-20 19:35:13
set PATH $PATH /home/maddy/.local/bin
