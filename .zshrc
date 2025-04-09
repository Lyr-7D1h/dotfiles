# zmodload zsh/zprof
if [ ! -d ~/.zplug ]; then 
	echo "Installing zplug"
	curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

### Plugins
source ~/.zplug/init.zsh
export ZPLUG_HOME=/home/lyr/.zplug
# zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
# zplug "plugins/aws", from:oh-my-zsh
# zplug "plugins/poetry", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions"
zplug "romkatv/powerlevel10k", as:theme, depth:1

zplug "plugins/tmux", from:oh-my-zsh, defer:2
zplug "plugins/git-auto-fetch", from:oh-my-zsh, defer:2
zplug "loiccoyle/zsh-github-copilot", defer:2
zplug "plugins/terraform", from:oh-my-zsh, defer:2
zplug "plugins/npm", from:oh-my-zsh, defer:2
zplug "plugins/docker", from:oh-my-zsh, defer:2
zplug "plugins/docker-compose", from:oh-my-zsh, defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
# zplug "zplug/zplug", hook-build: 'zplug --self-manage'

if ! zplug check ; then
      zplug install
fi

zplug load 

GIT_AUTO_FETCH_INTERVAL=1200 # in seconds

# ZSH-AUTOSUGGESTIONS
# https://github.com/zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion match_prev_cmd)
ZSH_AUTOSUGGEST_USE_ASYNC=true

CASE_SENSITIVE="true"

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

# ZStyle
# Do menu-driven completion.
zstyle ':completion:*' menu select

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''



### Autocompletions
autoload bashcompinit && bashcompinit
autoload -U compinit && compinit

# if command -v aws_compiler &> /dev/null; then
#   complete -C `which aws_completer` aws
# fi

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

# CTRL-T - create new tmux session with directory name, or attach to existing one
tmux_inserter() {
  name=( $(basename `pwd`) )

  if [[ $(tmux ls -F "#S" | grep "$name" ) ]]; then
    zle push-line 
    BUFFER="tmux attach-session -t $name"
    zle accept-line

    return
  fi

  zle push-line # Clear buffer. Auto-restored on next prompt.
  BUFFER="tmux new-session -s "$name""
  zle accept-line

  zle reset-prompt
  return
}
zle -N tmux_inserter 
bindkey '^T' tmux_inserter

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

# copilot
bindkey '^[I' zsh_gh_copilot_explain  # bind Alt+shift+I to explain
bindkey '^[i' zsh_gh_copilot_suggest  # bind Alt+i to suggest


### Aliases
alias g="git"
alias grc="git rebase --continue"
alias ga="git add"
alias gsw="git switch"
alias gst="git status"
alias gb="git branch"
alias gc="git commit -v"
alias gch="git checkout"
alias gchb="git checkout -b"
alias gca="git commit -a"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gda="git diff -a"
alias gd="git diff"
alias gp="git push"
alias gf="git fetch"
alias gfa="git fetch --all"
alias ls='ls --color=auto'
alias tf='terraform'
# Fix screen coloring since most remote clients don't support alacritty
alias ssh='TERM=xterm ssh'
alias update='home-manager switch'
alias vim='nvim'
alias tvim="tmux new-session nvim"
if command -v bat &>/dev/null ; then
  alias cat="bat -P -p"
fi
# Refresh sudo session
alias sudo='sudo -v; sudo '
alias csway="vim ~/.config/sway/config"
alias clsp="vim ~/.config/nvim/lua/lsp.lua"
alias cplugin="vim ~/.config/nvim/lua/plugins.lua"
alias cvim="vim ~/.config/nvim/init.lua"
alias n="note"
alias py="python"

# alias clip="export SCREENSHOT_FILENAME=$HOME/Pictures/screenshots/scrn-$(date +"%Y-%m-%d-%H-%M-%S").png && slurp | grim -g - $SCREENSHOT_FILENAME && cat $SCREENSHOT_FILENAME | wl-copy"


### Functions
kaws() {
  selected=$(aws configure list-profiles | fzf)
  export AWS_PROFILE=$selected
}
# lazy load kubectl autocomplete
# function kubectl() {
#     if ! type __start_kubectl >/dev/null 2>&1; then
#         source <(command kubectl completion zsh)
#     fi
#
#     command kubectl "$@"
# }
ktx() {
  # current="$(kubectl config current-context)"
  selected="$(kubectl config get-contexts -o name | fzf)"
  # selected=$( (kubectl config view -o jsonpath="{.contexts[?(@.name != "${current}")].name}" | xargs -n 1; echo "${current}" ) | fzf -0 -1 --tac -q "${1:-""}" --prompt "$current> ")
  if [ ! -z "$selected" ]; then
      kubectl config use-context "${selected}"
  fi
}


### Autoloads
# Asdf
if [[ -f /opt/asdf-vm/asdf.sh ]]; then
  . /opt/asdf-vm/asdf.sh
fi

# Keep same directory in gnome-terminal
if [[ "$GNOME_TERMINAL_SCREEN" != "" ]]; then
  . /etc/profile.d/vte.sh
fi

# Adding Pyenv
if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/usr/etc/profile.d/conda.sh" ]; then
#         . "/usr/etc/profile.d/conda.sh"
#     else
#         export PATH="/usr/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<

# Source any secret environment variables
if [[ -f ~/.secrets ]]; then
	set -a
	source ~/.secrets
	set +a
fi

### Exports
export DOCKER_BUILDKIT=0
export FZF_DEFAULT_COMMAND='rg --files'
export LANG=en_US.UTF-8
export BROWSER="firefox"
export DEBUGINFOD_URLS="https://debuginfod.archlinux.org"
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi


# Adding go
if command -v go > /dev/null; then
  export PATH=$PATH:/usr/local/go/bin
  export PATH=$PATH:$(go env GOPATH)/bin
fi

if command -v symfony > /dev/null; then
   export PATH="$HOME/.symfony5/bin:$PATH"
fi

# Adding espup
export LIBCLANG_PATH="/home/lyr/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-16.0.4-20231113/esp-clang/lib"
export PATH="/home/lyr/.rustup/toolchains/esp/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/bin:$PATH"

# Adding custom executables
export PATH="$PATH:$HOME/.npm/bin"
# Adding local bin to path
export PATH="$HOME/.local/bin:$PATH"
# Cargo executables
export PATH="$HOME/.cargo/bin:$PATH"


# Add Deno Install
export DENO_INSTALL="/home/lyr/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Add gem executables
export PATH="$PATH:$HOME/.gem/ruby/2.7.0/bin"

# Added by serverless binary installer
export PATH="$HOME/.serverless/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

# Adding custom executables
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/pbin:$PATH"

# HACK: something overwrites this in zprofile
# export WAYLAND_DISPLAY=wayland-0
# zprof
