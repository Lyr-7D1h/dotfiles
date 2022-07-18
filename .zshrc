# Performance testing using 'zprof'
# zmodload zsh/zprof

# Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

### Plugins
source ~/.zplug/init.zsh
export ZPLUG_HOME=/home/lyr/.zplug
# zplug "plugins/kubectl", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh
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
HISTSIZE="10000"
SAVEHIST="10000"
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
bindkey '^n' autosuggest-accept

autoload -Uz select-word-style
select-word-style bash

x-backward-kill-word(){
  WORDCHARS='*?_-[]~\!#$%^(){}<>|`@#$%^*()+:?' zle backward-kill-word
}
zle -N x-backward-kill-word

# alt + backspace 
bindkey '^[^?' x-backward-kill-word

# alt + delete remove word
bindkey '^[[3;5~' kill-word

# Enable reverse search
bindkey '^R' history-incremental-search-backward

# alt + <- and alt + -> move a word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char




### Exports
# Adding custom executables
export PATH="$PATH:$HOME/.npm/bin"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
# You may need to manually set your language environment
export LANG=en_US.UTF-8
# Needed for obs on wayland
export QT_QPA_PLATFORM=wayland


### Aliases
alias configure='vim ~/.config/nixpkgs/home.nix'
alias ls='ls --color=auto'
# Fix screen coloring since most remote clients don't support alacritty
alias ssh='TERM=xterm ssh'
alias tf='terraform'
alias update='home-manager switch'
alias vim='nvim'
# Refresh sudo session
alias sudo='sudo -v; sudo '
# added by latest_cd
alias cd="FROM_CD_ALIAS=true . latest_cd"
alias lcd="cd $(latest_cd)"
alias csway="vim ~/.config/sway/config"

### Functions
kaws() {
  selected=$(aws configure list-profiles | fzf)
  export AWS_PROFILE=$selected
}
ktx() {
  current="$(kubectl config current-context)"
  selected=$( (kubectl config view -o jsonpath="{.contexts[?(@.name != "${current}")].name}" | xargs -n 1; echo "${current}" ) | fzf -0 -1 --tac -q "${1:-""}" --prompt "$current> ")
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
