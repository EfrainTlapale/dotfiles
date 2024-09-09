# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

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
plugins=(git gitfast zsh-autosuggestions)

bindkey '^ ' autosuggest-accept

source $ZSH/oh-my-zsh.sh

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
alias dkd='docker-compose down --remove-orphans -t0'
alias dkl='docker-compose pull'
alias dku='docker-compose up -d'

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

dkcd-static() {
  ORIGINAL_PATH=$(pwd)
  cd $HOME/deploy/my-app-frontend/latest
  dkd
  cd ../../my-app-backend/latest
  dkd
  cd ../../my-server/latest
  dkd
  cd $ORIGINAL_PATH
}

ansible-deploy-static() {
  ORIGINAL_PATH=$(pwd)
  cd ~/work/ansible-config #point here to ansible repo
    if [ $# = 1 ]
  then
    git pull
    git checkout $1
  else
    git checkout latest
  fi
  git pull
  cd docker
  dku
  docker exec -it ansible bash ./commands/local_deploy.sh internal my-server
  cd $HOME/deploy/my-server/latest
  dkl
  dku
  docker stop chrome-gui-my-server
  docker stop frontend-my-server
  code docker-compose.yml #open vs code to manually comment out chrome-gui and frontend for now
  docker exec -it ansible bash ./commands/local_deploy.sh internal my-app-frontend root
  cd $HOME/deploy/my-app-frontend/latest
  dkl
  dku
  docker exec -it ansible bash ./commands/local_deploy.sh internal my-app-backend root
  cd $HOME/deploy/my-app-backend/latest
  dku
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
  fd -I trace.zip -x npx playwright show-trace
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# What OS are we running?
if [[ $(uname) == "Darwin" ]]; then
  export XDG_CONFIG_HOME="$HOME/.config"
fi

if [[ $(uname) == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

