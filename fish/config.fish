set -gx HOMEBREW_PREFIX /opt/homebrew
set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
set -gx HOMEBREW_REPOSITORY /opt/homebrew
fish_add_path /opt/homebrew/bin /opt/homebrew/sbin

# --- Aliases ---
alias nv "nvim"
alias tailscale "/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias ohmyzsh "mate ~/.oh-my-zsh"

# --- Path additions ---
fish_add_path /Applications/Blender.app/Contents/MacOS
fish_add_path /opt/homebrew/opt/python/libexec/bin
fish_add_path $HOME/go/bin

if type -q brew
    fish_add_path (brew --prefix llvm)/bin
end

# --- Environment variables ---
set -gx GOPATH $HOME/go
set -gx OPENSSL_ROOT_DIR /opt/homebrew/opt/openssl@3

# --- fzf ---
set -gx FZF_DEFAULT_OPTS "--height=40% --preview='cat {}' --preview-window=right:60%:wrap"

if test -d /usr/local/opt/fzf
    set -gx FZF_BASE /usr/local/opt/fzf
    fish_add_path $FZF_BASE/bin
end

if type -q fzf
    fzf --fish | source
end

# --- Helper functions ---
function mcd --description "mkdir and cd into it"
    mkdir -p $argv[1]; and cd $argv[1]
end

# --- Cargo/Rustup (replaces sourcing ~/.local/bin/env) ---
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin

set -gx TERM xterm-256color

function t --description "sesh session picker"
    set -lx FZF_DEFAULT_OPTS "--height=40% --reverse --border-label ' sesh ' --border --prompt 'Φ  '"
    set session (sesh list -t -c | fzf)
    test -z "$session"; and return
    if set -q TMUX
        tmux switch-client -t $session
    else
        tmux new-session -A -s $session
    end
end

bind \ek 'commandline -r "t"; commandline -f execute'

zoxide init fish | source
