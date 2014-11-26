#Make sure never to forget to use time on long running functions
export REPORTTIME=10

# Make sure the correct editor is used
export EDITOR="/usr/bin/vim"

# Python virtual envs
if [[ -r /usr/bin/virtualenvwrapper_lazy.sh ]]; then
    source /usr/bin/virtualenvwrapper_lazy.sh
fi

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/home/wichtounet/build/modular-boost/lib:/home/wichtounet/install/lib"

#Complete the path
#export PATH="/usr/lib64/ccache/bin:$PATH"
export PATH="/home/wichtounet/build/tmsu-0.2.0/bin/:$PATH"
export PATH="/home/wichtounet/opt/cross/bin/:$PATH"

#Configure CCache
#export CCACHE_DIR="/data/ccache"
#export CCACHE_SIZE="8G"

export GOPATH="/home/wichtounet/dev/gocode/"

export JAVA_HOME="/etc/java-config-2/current-system-vm"
export _JAVA_AWT_WM_NONREPARENTING=1

# Force pdflatex to print with lots of columns
export max_print_line=100000

# Include stuff thas is local to the computer
if [[ -r ~/.local.zshrc ]]; then
	source ~/.local.zshrc
fi

# Enable colors
autoload -U colors && colors

# Allow for functions in the prompt
setopt PROMPT_SUBST

# Configure completion for taskwarrior
fpath=($fpath /usr/local/share/doc/task/scripts/zsh)

# Enable completion
autoload -Uz compinit && compinit

# Enable correction
setopt correctall

# Enable advanced prompt
autoload -U promptinit && promptinit

#Cache for completions
zstyle ':completion::complete:*' use-cache 1

# Completion style improvements
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Group by tag names
zstyle ':completion:*' group-name ''

# Define the output of the time command
TIMEFMT=$'real\t%E\nuser\t%U\nsys\t%S'

# Basic history configuration
export HISTSIZE=2000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt inc_append_history

# Improve duplicate configuration
setopt hist_ignore_all_dups

# Enable oh-my-zsh
export ZSH=$HOME/.oh-my-zsh

export DEFAULT_USER="wichtounet"
export ZSH_THEME="agnoster"
plugins=(autojump git git-flow taskwarrior gpg-agent ssh-agent zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#Always display the line where grep found something
alias grep='grep -n'

#Utility aliases for git
alias gc='git commit'
alias gca='git commit -a'
alias gcadd='git add -A'

# Misc aliases
alias lla='ls -la'
alias mkdir='mkdir -pv'
alias mounts='mount |column -t'
alias ports='netstat -tulanp'
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias wget='wget -c'
alias df='df -H'
alias du='du -d1 -h'
alias sorry='sudo $(fc -l -n -1)'
alias asshole='echo Alright. You do not have to be rude, you know. && sleep 0.8 && sudo $(fc -l -n -1)'

alias gcc_make='make CXX=g++-4.9.1 LD=g++-4.9.1'

alias pump_make='pump make -j16 CXX="distcc /usr/bin/clang++" CC="distcc /usr/bin/clang"'

# Copy with pv
function pvcp(){
  SOURCE=$1

  if [ -d $2 ]
  then
    DESTINATION=$2/`basename $SOURCE`
  else
    DESTINATION=$2
  fi

  pv ${SOURCE} | > ${DESTINATION}
}

# mdless function
function mdless(){
  pandoc -s -f markdown -t man $1 | groff -T utf8 -man | less
}

function pygmentize_cat {
    for arg in "$@" ; do
        pygmentize -g "${arg}" 2> /dev/null || /bin/cat "${arg}"
    done
}

command -v pygmentize > /dev/null && alias pcat=pygmentize_cat

function ranger-cd {
  tempfile='/tmp/chosendir'
  ranger --choosedir="$tempfile" "${@:-$(pwd)}"
  test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
}

bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
bindkey -M vicmd 'j' history-beginning-search-forward
bindkey -M vicmd 'k' history-beginning-search-backward

export CC=clang
export CXX=clang++
export LD=clang++

alias nano='vim'
