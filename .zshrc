# Keep $path (and so $PATH) free of duplicates, so re-sourcing this file
# doesn't grow PATH every time.
typeset -U path PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="minimal"

plugins=(gitfast zsh-autosuggestions)


source $ZSH/oh-my-zsh.sh

bindkey '^ ' autosuggest-accept
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^G' edit-command-line

# -------
# GIT Aliases
# -------
alias gs='git status'
alias gpnb='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias lg='lazygit'
alias glg="git log --graph --pretty=format:'%C(auto)%h%d %s %C(dim white)(%ar)%Creset %C(blue)%cn%Creset'"
alias gss='git status --short'
alias gc='git commit --message'
alias gl='git pull'
alias gp='git push'
alias gca='git commit --all --message'

# cd into a worktree of the current repo, as laid out by `git wta` (.git-config-base).
_worktree_root() {
  local common
  common=$(git rev-parse --git-common-dir 2>/dev/null) || return 1
  print -r -- "$HOME/worktrees/$(basename "$(cd "$common/.." && pwd)")"
}

gwtcd() {
  local root
  root=$(_worktree_root) || {
    echo "gwtcd: not inside a git repository" >&2
    return 1
  }
  cd "$root/$1"
}

_gwtcd() {
  local root
  root=$(_worktree_root) || return 1
  _path_files -W "$root" -/
}
compdef _gwtcd gwtcd

connectBtDevice() {
  if [[ $(uname) == "Darwin" ]]; then
    blueutil --connect $1
  else
    bluetoothctl connect $1
  fi
}

toggle_keyboard_control() {
  local keyboard_name="AT Translated Set 2 keyboard"
  local state_dir="${XDG_RUNTIME_DIR:-/tmp}/toggle-keyboard"
  local pid_file="$state_dir/grab.pid"

  local event=$(awk -v name="$keyboard_name" '
    /^N: Name=/ { found = index($0, "\"" name "\"") > 0 }
    found && /^H: Handlers=/ {
      for (i = 1; i <= NF; i++) if ($i ~ /^event[0-9]+$/) { print $i; exit }
    }
  ' /proc/bus/input/devices)

  if [[ -z "$event" ]]; then
    echo "❌ Could not find event device for '$keyboard_name'."
    return 1
  fi
  local dev="/dev/input/$event"

  mkdir -p "$state_dir"

  if [[ -f "$pid_file" ]] && kill -0 "$(cat "$pid_file")" 2>/dev/null; then
    echo "🔄 Reattaching keyboard ($dev)"
    kill "$(cat "$pid_file")"
    rm -f "$pid_file"
    notify-send "🔌 Keyboard Reattached" "Keyboard input restored."
  else
    if [[ ! -r "$dev" ]]; then
      echo "❌ Can't read $dev — add yourself to the 'input' group:"
      echo "   sudo usermod -aG input \$USER   (then log out and back in)"
      return 1
    fi

    echo "🧊 Floating keyboard ($dev)"
    libinput debug-events --grab --device "$dev" >/dev/null 2>&1 &
    disown
    echo $! >"$pid_file"

    notify-send "⛔️ Keyboard Floated" "Input disabled, palm detection off."
  fi
}


function toggle_touchpad() {
    # Define the GNOME settings schema and key
    local schema="org.gnome.desktop.peripherals.touchpad"
    local key="send-events"
    
    # Get the current state
    local current_state=$(gsettings get $schema $key)

    if [[ "$current_state" == "'disabled'" ]]; then
        # ENABLE LOGIC
        gsettings set $schema $key 'enabled'
        echo "Touchpad: Enabled 🟢"
        
        # Notification with Green Circle and Pointing Finger
        notify-send "Touchpad Enabled 🟢" "Touch controls are active 👆" \
            -i input-touchpad-on \
            -h string:x-canonical-private-synchronous:touchpad-toggle

    else
        # DISABLE LOGIC
        gsettings set $schema $key 'disabled'
        echo "Touchpad: Disabled 🔴"
        
        # Notification with Red Circle and Crossed Mark
        notify-send "Touchpad Disabled 🔴" "Touch controls are locked 🚫" \
            -i input-touchpad-off \
            -h string:x-canonical-private-synchronous:touchpad-toggle
    fi
}


export GPG_TTY=$(tty)
(( $+commands[zoxide] )) && eval "$(zoxide init --cmd j zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# What OS are we running?
if [[ $OSTYPE == darwin* ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
  # Created by `pipx` on 2026-02-03 02:02:48
  path+=("$HOME/.local/bin")
else
  # Homebrew, when installed. Also puts `brew`-managed tools on PATH.
  [ -x /home/linuxbrew/.linuxbrew/bin/brew ] &&
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# fzf keybindings + completion. A git install writes ~/.fzf.zsh (which also
# puts ~/.fzf/bin on PATH); package installs just have fzf on PATH already.
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
elif (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi


# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Shell integration (OSC 133 semantic zones, used by the wezterm.lua keybinds).
[ -f "$HOME/wezterm.sh" ] && . "$HOME/wezterm.sh"

# Go binaries. Using the default GOPATH instead of shelling out to `go env`
# drops a subprocess from every shell start, and stops this line from printing
# "command not found" on machines without Go.
[ -d "${GOPATH:-$HOME/go}/bin" ] && path=("${GOPATH:-$HOME/go}/bin" $path)

[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"


export EDITOR=nvim
export VISUAL="$EDITOR"

export PATH="$HOME/.local/bin:$PATH"

[ -d /Library/Java/JavaVirtualMachines/zulu-17.jdk ] && \
  export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

if [ -d "$HOME/Library/Android/sdk" ]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path+=("$ANDROID_HOME/emulator" "$ANDROID_HOME/platform-tools")
fi

# Machine-local config (device addresses, per-host aliases) - not tracked.
[ -f "$HOME/.zshrc.local" ] && . "$HOME/.zshrc.local"
