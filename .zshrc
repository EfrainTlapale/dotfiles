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

gwtcd() {
  local repo
  repo=$(cd "$(git rev-parse --git-common-dir)/.." && basename "$PWD") || return
  cd "$HOME/worktrees/$repo/$1"
}

# -------
# Docker Aliases
# -------
alias dkp='docker ps'
dksh() {
  docker exec -it $1 bash
}

app-cli() {
  docker exec -it my-app-frontend  app-cli
}

complete -F _custom_docker_exec_completion dksh
alias dkl='docker-compose pull'
alias dkd='docker compose down --remove-orphans -t0'
alias dku='docker compose up -d'

run-local-stack() {
  ORIGINAL_PATH=$(pwd)
  local flag_s flag_c

  while getopts "sc" opt; do
      case $opt in
          s) flag_s=true ;;
          c) flag_c=true ;;
          *) echo "Usage: my_function -sc" ; return 1 ;;
      esac
  done

  if [[ $flag_s ]]; then
      cd $HOME/deploy/my-server/latest
      dku
  fi

  if [[ $flag_c ]]; then
      cd $HOME/deploy/my-app/latest
      dku
  fi
  cd $ORIGINAL_PATH
}

stop-local-stack() {
  ORIGINAL_PATH=$(pwd)
  local flag_s flag_c

  while getopts "sc" opt; do
      case $opt in
          s) flag_s=true ;;
          c) flag_c=true ;;
          *) echo "Usage: my_function -sc" ; return 1 ;;
      esac
  done

  if [[ $flag_c ]]; then
      cd $HOME/deploy/my-app/latest
      dkd
  fi

  if [[ $flag_s ]]; then
      cd $HOME/deploy/my-server/latest
      dkd
  fi
  cd $ORIGINAL_PATH
}

connectBtDevice() {
  if [[ $(uname) == "Darwin" ]]; then
    blueutil --connect $1
  else
    bluetoothctl connect $1
  fi
}

toggle_keyboard_control() {
  local keyboard_name="AT Translated Set 2 keyboard"
  local keyboard_id=$(xinput | grep "$keyboard_name" | grep -Eo '[0-9]+' | head -2 | tail -1)

  if [[ -z "$keyboard_id" ]]; then
    echo "❌ Could not find keyboard ID for '$keyboard_name'."
    return 1
  fi

  if xinput | grep -A0 "$keyboard_name" | grep -q 'floating'; then
    echo "🔄 Reattaching keyboard (ID: $keyboard_id)"
    xinput reattach "$keyboard_id" 3
    notify-send "🔌 Keyboard Reattached" "Keyboard input restored."
  else
    echo "🧊 Floating keyboard (ID: $keyboard_id)"
    xinput float "$keyboard_id"

    local touchpad_id=$(xinput | grep -i touchpad | grep -Eo 'id=[0-9]+' | grep -Eo '[0-9]+')
    if [[ -n "$touchpad_id" ]]; then
      xinput set-prop "$touchpad_id" "libinput Tapping Enabled" 1 2>/dev/null
      xinput set-prop "$touchpad_id" "libinput Disable While Typing Enabled" 0 2>/dev/null
      echo "✅ Tap-to-click and touchpad during typing enabled (ID: $touchpad_id)"
    else
      echo "⚠️  Touchpad not found."
    fi

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

# Personal aliases
alias connect-wf='connectBtDevice AA:BB:CC:DD:EE:01'
alias connect-wh='connectBtDevice AA:BB:CC:DD:EE:02'
alias connect-pods='connectBtDevice AA:BB:CC:DD:EE:03'
alias connect-mouse='connectBtDevice AA:BB:CC:DD:EE:04' 
alias connect-ora='connectBtDevice AA:BB:CC:DD:EE:05' 

showTestVideo() {
  fd -I .webm -x xdg-open
}

showTestTrace() {
  fd -I trace.zip -x npx playwright@latest show-trace
}

fixFrontAssetManagement(){
  sudo rm $HOME/deploy/my-app-frontend/data/state.json
}

fixBackAssetManagement(){
  sudo rm $HOME/deploy/my-app-backend/data/state.json
}




export GPG_TTY=$(tty)
eval "$(zoxide init --cmd j zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
  source <(fzf --zsh)
  # Created by `pipx` on 2026-02-03 02:02:48
  export PATH="$PATH:/Users/efra/.local/bin"
fi

if [[ $(uname) == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi


# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

docker_psf() {
  docker ps --format '{{.Names}}\t{{.Image}}' | awk -F '\t' '
  BEGIN {
    # Define ANSI colors
    name_color = "\033[1;36m"   # Cyan
    image_color = "\033[1;32m"  # Green
    reset = "\033[0m"

    # Print headers
    printf "%s%-25s\t%-25s\t%-10s%s\n", name_color, "CONTAINER NAME", "IMAGE NAME", "VERSION", reset
  }
  {
    # Split image into name and version
    split($2, image_parts, ":");
    image_name = image_parts[1];
    version = (length(image_parts) > 1) ? image_parts[2] : "latest";

    # Print row with colors
    printf "%s%-25s\t%s%-25s\t%-10s%s\n", name_color, $1, image_color, image_name, version, reset
  }'
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

. $HOME/wezterm.sh

export PATH=$(go env GOPATH)/bin:$PATH
. "$HOME/.deno/env"


export EDITOR=nvim
export VISUAL="$EDITOR"

