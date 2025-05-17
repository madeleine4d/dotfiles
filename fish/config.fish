if status is-interactive
    # Commands to run in interactive sessions can go here
end

starship init fish | source
starship preset catppuccin-powerline -o ~/.config/starship.toml

set -g fish_key_bindings fish_vi_key_bindings

set -gx EDITOR nvim
set fish_greeting
neofetch
