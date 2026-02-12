# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(gitfast zsh-autosuggestions)


source $ZSH/oh-my-zsh.sh

bindkey -v

bindkey -M viins '^ ' autosuggest-accept
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#
# -------
# GIT Aliases
# -------
alias gs='git status'
alias gpnb='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias lg='lazygit'
alias glg='git log'
alias gss='git status --short'
alias gc='git commit --message'
alias gl='git pull'
alias gp='git push'
alias gca='git commit --all --message'

# -------
# Docker Aliases
# -------
alias dkp='docker ps'
dksh() {
  docker exec -it $1 bash
}

# _completion_loader docker exec
# _custom_docker_exec_completion() {
#     local cur prev words cword;
#     _get_comp_words_by_ref -n : cur prev words cword;
#     _docker_container_exec
# }

app-cli() {
  docker exec -it my-app-frontend  app-cli
}

complete -F _custom_docker_exec_completion dksh
alias dkl='docker-compose pull'
alias dkd='docker compose down --remove-orphans -t0'
alias dku='docker compose up -d'

dkcu-static() {
  ORIGINAL_PATH=$(pwd)
  cd $HOME/deploy/my-server/latest
  dkl
  dku
  cd ../../my-app-frontend/latest
  dkl
  dku
  if [ $# != 1 ]; then
    cd ../../my-app-backend/latest
    dku
  fi
  cd $ORIGINAL_PATH
}

dkcu-server() {
  ORIGINAL_PATH=$(pwd)
  cd $HOME/deploy/my-server/latest
  dkl
  dku
  cd $ORIGINAL_PATH
}

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

pyprettier() {
  docker exec -it django-app-my-server black .
}

flake8() {
  docker exec -it django-app-my-server flake8 .
}

isort() {
   docker exec -it django-app-my-server isort .
}

connectBtDevice() {
  if [[ $(uname) == "Darwin" ]]; then
    blueutil --connect $1
  else
    bluetoothctl connect $1
  fi
}

float_keyboard() {
  local number
  number=$(xinput | grep 'AT Translated Set 2 keyboard' | grep -Eo '[0-9]+' | head -2 | tail -1)
  xinput float "$number"
}

reattach_keyboard() {
  local number
  number=$(xinput | grep floating | grep -Eo '[0-9]+' | head -2 | tail -1)
  xinput reattach "$number" 3
}

float_keyboard_and_fix_touchpad() {
  # Get keyboard ID (adjust the grep if your keyboard name differs)
  local keyboard_id=$(xinput | grep 'AT Translated Set 2 keyboard' | grep -Eo '[0-9]+' | head -2 | tail -1)

  if [[ -z "$keyboard_id" ]]; then
    echo "❌ Could not find keyboard ID."
    return 1
  fi

  echo "🧊 Floating keyboard (ID: $keyboard_id)"
  xinput float "$keyboard_id"

  # Find the touchpad ID
  local touchpad_id=$(xinput | grep -i touchpad | grep -Eo 'id=[0-9]+' | grep -Eo '[0-9]+')
  if [[ -z "$touchpad_id" ]]; then
    echo "⚠️  Touchpad not found."
    return 1
  fi

  # Re-enable tap-to-click (some systems might use a different prop name)
  echo "✅ Enabling tap-to-click on touchpad (ID: $touchpad_id)"
  xinput set-prop "$touchpad_id" "libinput Tapping Enabled" 1
}

reattach_keyboard2() {
  local keyboard_id=$(xinput | grep 'AT Translated Set 2 keyboard' | grep -Eo '[0-9]+' | head -2 | tail -1)

  if [[ -z "$keyboard_id" ]]; then
    echo "❌ Could not find keyboard ID."
    return 1
  fi

  echo "🔄 Reattaching keyboard (ID: $keyboard_id) to master 3"
  xinput reattach "$keyboard_id" 3
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

# export NVM_DIR="/usr/local/opt/nvm"
# # [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm (commented out because slow, see Custom script below)
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@" # Custom: only load nvm upon first use, because it is slow



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


