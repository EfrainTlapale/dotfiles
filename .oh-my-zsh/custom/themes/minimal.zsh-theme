# minimal.zsh-theme
# A super simple, single-line prompt: truncated path, git branch, arrow.
# Colors are pulled from the noir neovim colorscheme for consistency.

setopt PROMPT_SUBST

typeset -g __path_fg='#9BBEFF'   # vivid blue   - current directory (noir accent)
typeset -g __ok_fg='#9BBEFF'     # vivid blue   - prompt char, last command ok
typeset -g __err_fg='#E0908F'    # vivid coral  - prompt char, last command failed
typeset -g __git_fg='#9ECFA5'    # vivid green  - clean git branch
typeset -g __dirty_fg='#D9C08C'  # vivid amber  - dirty git marker

ZSH_THEME_GIT_PROMPT_PREFIX=" %F{$__git_fg}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY=" %F{$__dirty_fg}●%f"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Swap the prompt char glyph when dropping into vi normal mode ("bindkey -v").
typeset -g __vi_char='❯'

function zle-line-init {
  __vi_char='❯'
}
function zle-keymap-select {
  __vi_char=$([[ $KEYMAP == vicmd ]] && echo '❮' || echo '❯')
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Path truncates to ".../last three" once it gets more than 5 segments deep.
PROMPT='%F{$__path_fg}%(5~|…/%3~|%~)%f$(git_prompt_info) %(?.%F{$__ok_fg}.%F{$__err_fg})${__vi_char}%f '
