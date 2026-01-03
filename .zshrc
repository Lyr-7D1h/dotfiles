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
# Exit early for non-interactive shells to avoid expensive startup work
[[ $- == *i* ]] || return

# Set ZPLUG_HOME before sourcing zplug to avoid extra lookups
export ZPLUG_HOME=/home/lyr/.zplug
source ~/.zplug/init.zsh

# Lazy-load some heavier plugins to improve interactive startup time
zplug "Aloxaf/fzf-tab", defer:2
# zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
# zplug "plugins/aws", from:oh-my-zsh
# zplug "plugins/poetry", from:oh-my-zsh
zplug "zsh-users/zsh-autosuggestions", defer:2
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
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' prefix ''
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# custom fzf flags
# NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
# To make fzf-tab follow FZF_DEFAULT_OPTS.
# NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
zstyle ':fzf-tab:*' use-fzf-default-opts yes
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# Fix ctrl+u after fzf-tab
bindkey '^U' backward-kill-line

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
# zstyle ':completion:*' verbose yes
# zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
# zstyle ':completion:*:messages' format '%d'
# zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
# zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# zstyle ':completion:*' group-name ''


### Exports
# always set utf-8 locale for shell
export LC_ALL=C.UTF-8
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

if command -v julia > /dev/null; then
	export PATH="$PATH:/path/to/your/julia/bin"
fi

if command -v symfony > /dev/null; then
   export PATH="$HOME/.symfony5/bin:$PATH"
fi

# Adding espup
# export LIBCLANG_PATH="/home/lyr/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-16.0.4-20231113/esp-clang/lib"
# export PATH="/home/lyr/.rustup/toolchains/esp/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/bin:$PATH"

# Adding custom executables
export PATH="$PATH:$HOME/.npm/bin"
# Adding local bin to path
export PATH="$HOME/.local/bin:$PATH"
# Cargo executables
export PATH="$HOME/.cargo/bin:$PATH"

# Add Deno Install
export DENO_INSTALL="/home/lyr/.deno"

# Nvm - lazy load to improve startup time
export NVM_DIR="$HOME/.nvm"
# Only set up nvm when it's actually called
nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
# Lazy load node, npm, npx as well
node() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  node "$@"
}
npm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npm "$@"
}
npx() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  npx "$@"
}

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


### Autocompletions
autoload bashcompinit && bashcompinit
autoload -U compinit && compinit -u

# [JJ autocomplete](https://jj-vcs.github.io/jj/latest/install-and-setup/#zsh)
if command -v jj &> /dev/null; then
	# Dynamic autocompletion
	source <(COMPLETE=zsh jj)
fi

# if command -v aws_compiler &> /dev/null; then
#   complete -C `which aws_completer` aws
# fi

# Helm autocompletaion
if command -v helm &> /dev/null; then
  source <(helm completion zsh)
fi

# Git overwrite branch autocompletion to sort by most recent
_git-most-recent() {
	local -a recent branches

	recent=(${(f)"$(git for-each-ref --sort=-committerdate --format='%(refname:short)' refs/heads | head -n 10)"})
  branches=(${(f)"$(git for-each-ref --format='%(refname:short)' refs/heads)"})
  # Remove branches that are in 'recent' from 'all_branches'
  # branches=(${branches:|recent})
	_describe -t branches 'local branches' recent 
  _describe -t all-branches 'other branches' branches && return
}
# overwrites switch command
_git-switch() {
  _git-most-recent
}
# needed to overwrite checkout
compdef _git_checkout git-checkout

### Keybindings
# set emacs keybinds (ctrl+a, ctrl+e)
bindkey -e

# ctrl + space to accept suggestions
bindkey '^N' autosuggest-accept

function insert_ai_commit_message() {
  LBUFFER+="Write a commit message using jj describe -m '{message}' using the given diff. Follow the Conventional Commits format strictly for commit messages. Use the structure: <type>[optional scope]: <description>. Guidelines: 1. **Type and Scope**: Choose an appropriate type (e.g., 'feat', 'fix') and optional scope to describe the affected module or feature. 2. **Description**: Write a concise, informative description in the header; use backticks if referencing code or specific terms. Commit messages should be concise, clear, informative, and professional, aiding readability and project tracking, try to prevent too many generic terms.

'$(jj diff --no-pager)'"
}
zle -N insert_ai_commit_message
bindkey '^_' insert_ai_commit_message  

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
alias gsth="git stash"
alias gsthp="git stash pop"
alias gstha="git stash apply"

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

alias lunch="curl 'http://icarus.prod.virt.i.bitonic.nl:1439/add?name=Ivo'"

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
# Remove all local bookmarks that don't exist in remote
jj-prune () {
  set -e
  jj git fetch 
  for bm in $(jj bookmark list | awk '{print $1}'); do
	# detect if any remote matches
	if ! jj bookmark list --all-remotes | grep -q "^${bm}@"; then
		echo "$bm"
		# jj bookmark forget "$bm"
	fi
  done
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
# if command -v pyenv &> /dev/null; then
#     export PYENV_ROOT="$HOME/.pyenv"
#     export PATH="$PYENV_ROOT/bin:$PATH"
#     eval "$(pyenv init -)"
# fi

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


# HACK: something overwrites this in zprofile
# export WAYLAND_DISPLAY=wayland-0
# zprof

# pnpm
export PNPM_HOME="/home/lyr/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
