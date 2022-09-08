# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Performance testing using 'zprof'
# zmodload zsh/zprof

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

### Plugins
source ~/.zplug/init.zsh
export ZPLUG_HOME=/home/lyr/.zplug
# zplug "plugins/kubectl", from:oh-my-zsh
# zplug "plugins/git", from:oh-my-zsh
# zplug "plugins/aws", from:oh-my-zsh
zplug "plugins/terraform", from:oh-my-zsh
zplug "plugins/npm", from:oh-my-zsh
zplug "plugins/poetry", from:oh-my-zsh
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/docker-compose", from:oh-my-zsh
zplug "plugins/tmux", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "zplug/zplug", hook-build: 'zplug --self-manage'

if ! zplug check ; then
      zplug install
fi

zplug load 


# ZSH-AUTOSUGGESTIONS
# https://github.com/zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
ZSH_AUTOSUGGEST_USE_ASYNC=true

# History options
HISTSIZE="100000"
SAVEHIST="100000"
HISTFILE="$HOME/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"
setopt HIST_FCNTL_LOCK
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY
setopt autocd


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

### Autocompletions
autoload bashcompinit && bashcompinit
autoload -U compinit && compinit

if command -v aws_compiler &> /dev/null; then
  complete -C `which aws_completer` aws
fi

# Kubectl autocompletion
if command -v kubectl &> /dev/null; then
  # source <(kubectl completion zsh)
fi

# dotnet autocompletion
_dotnet_zsh_complete()
{
	local completions=("$(dotnet complete "$words")")

	reply=( "${(ps:\n:)completions}" )
}
compctl -K _dotnet_zsh_complete dotnet

# Helm autocompletaion
if command -v helm &> /dev/null; then
  source <(helm completion zsh)
fi

### Keybindings
# set emacs keybinds (ctrl+a, ctrl+e)
bindkey -e

# ctrl + space to accept suggestions
bindkey '^N' autosuggest-accept

# https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh
# ctrl + p - fzf for file path
__fzfcmd() {
  [ -n "$TMUX_PANE" ] && { [ "${FZF_TMUX:-0}" != 0 ] || [ -n "$FZF_TMUX_OPTS" ]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}
__fzfsel() {
  local cmd="rg --files --hidden --no-ignore-vcs --max-depth 8"
  # local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
  #   -o -type b,c,f,l,p,s -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local item
  eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}
fzf_get_file_path() {
  LBUFFER="${LBUFFER}$(__fzfsel)"
  local ret=$?
  zle reset-prompt
  return $ret
}
zle -N fzf_get_file_path
bindkey '^P' fzf_get_file_path

# ctrl + o - cd into the selected directory
fzf_find_directory() {
  local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 -maxdepth 4 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
    -o -type d -print 2> /dev/null | cut -b3-"}"
  setopt localoptions pipefail no_aliases 2> /dev/null
  local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
  if [[ -z "$dir" ]]; then
    zle redisplay
    return 0
  fi
  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="builtin cd -- ${(q)dir}"
  zle accept-line
  local ret=$?
  unset dir # ensure this doesn't end up appearing in prompt expansion
  zle reset-prompt
  return $ret
}
zle -N fzf_find_directory
bindkey '^O' fzf_find_directory

# CTRL-R - Paste the selected command from history into the command line
fzf_history() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null
  selected=( $(fc -rl 1 | perl -ne 'print if !$seen{(/^\s*[0-9]+\**\s+(.*)/, $1)}++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --reverse --bind=ctrl-r:toggle-sort,ctrl-z:ignore $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle reset-prompt
  return $ret
}
zle -N fzf_history
bindkey '^R' fzf_history 
# bindkey '^R' history-incremental-search-backward

autoload -Uz select-word-style
select-word-style bash

x_backward_kill_word(){
  WORDCHARS='*?_-[]~\!#$%^(){}<>|`@#$%^*()+:?' zle backward-kill-word
}
zle -N x_backward_kill_word
# alt + backspace 
bindkey '^[^?' x_backward_kill_word

# alt + delete remove word
bindkey '^[[3;5~' kill-word

# alt + <- and alt + -> move a word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word
# ctrl + <- and ctrl + -> move a word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char




### Aliases
alias g="git"
alias ga="git add"
alias gsw="git switch"
alias gst="git status"
alias gb="git branch"
alias gc="git commit -v"
alias gca="git commit -a"
alias gcam="git commit -am"
alias gda="git diff -a"
alias gd="git diff"
alias gp="git push"
alias gf="git fetch"
alias ls='ls --color=auto'
# Fix screen coloring since most remote clients don't support alacritty
alias ssh='TERM=xterm ssh'
alias tf='terraform'
alias update='home-manager switch'
alias vim='nvim'
alias tvim="tmux new-session nvim"
# Refresh sudo session
alias sudo='sudo -v; sudo '
# added by latest_cd
alias csway="vim ~/.config/sway/config"
alias clsp="vim ~/.config/nvim/lua/lsp.lua"
alias cplugin="vim ~/.config/nvim/lua/plugins.lua"
alias cvim="vim ~/.config/nvim/init.lua"


### Functions
kaws() {
  selected=$(aws configure list-profiles | fzf)
  export AWS_PROFILE=$selected
}
ktx() {
  # current="$(kubectl config current-context)"
  selected="$(kubectl config get-contexts -o name | fzf)"
  # selected=$( (kubectl config view -o jsonpath="{.contexts[?(@.name != "${current}")].name}" | xargs -n 1; echo "${current}" ) | fzf -0 -1 --tac -q "${1:-""}" --prompt "$current> ")
  if [ ! -z "$selected" ]; then
      kubectl config use-context "${selected}"
  fi
}

### Exports
export DOCKER_BUILDKIT=1
export FZF_DEFAULT_COMMAND='rg --files'

### Autoloads
# Asdf
if [[ -f /opt/asdf-vm/asdf.sh ]]; then
  . /opt/asdf-vm/asdf.sh
fi

# Keep same directory in gnome-terminal
if [[ "$GNOME_TERMINAL_SCREEN" != "" ]]; then
  . /etc/profile.d/vte.sh
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Pyenv
if command -v pyenv &> /dev/null; then
	export PYENV_ROOT="$HOME/.pyenv"
	export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi
