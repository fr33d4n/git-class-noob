echo 'Loading VM console...';

source ~/.git-completion.bash
source ~/.git-prompt.sh

# Automatically detect GOPATH routes
# https://stackoverflow.com/questions/17780754/automatically-defining-gopath-on-a-per-project-basis
cd () {
    builtin cd "$@"
    cdir=$PWD
    while [ "$cdir" != "/" ]; do
        if [ -e "$cdir/.gopath" ]; then
            export GOPATH=$cdir
            export GOBIN=$cdir/bin
            break
        fi
        cdir=$(dirname "$cdir")
    done
}
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# Configure colors, if available.
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  c_reset='\[\e[0m\]'
  c_user='\[\033[1;33m\]'
  c_path='\[\e[0;33m\]'
  c_git_clean='\[\e[0;36m\]'
  c_git_dirty='\[\e[0;35m\]'
  c_env='\[\e[0;32m\]'
  c_time='\[\e[0;34m\]'
else
  c_reset=
  c_user=
  c_path=
  c_git_clean=
  c_git_dirty=
  c_env=
  c_time=
fi

# Function to assemble the Git part of our prompt.
git_prompt ()
{
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 0
  fi

  git_branch=$(git branch 2>/dev/null| sed -n '/^\*/s/^\* //p')

  if git diff --quiet 2>/dev/null >&2; then
    git_color="$c_git_clean"
  else
    git_color="$c_git_dirty"
  fi

  echo " [$git_color$git_branch${c_reset}]"
}

# Looks for env folder/file and activates the it.
env_enabler() {
  if hash nvm 2>/dev/null; then
    NVMRC_FILE=`find $(pwd -P) -maxdepth 1 -name ".nvmrc" | head -1`
    if [ -f "$NVMRC_FILE" ]; then
      nvm use
    fi
  fi
}

env_cd() {
  \cd "$@" && env_enabler
}

# Thy holy prompt.
PROMPT_COMMAND='PS1="${c_time}\D{%T} ${c_time}${c_user}\u${c_reset}@${c_user}\h${c_reset}:${c_path}\w${c_reset}$(git_prompt)\$ "'


alias ll="ls -latrh"

# Git aliases
alias gpush="git push origin"
alias gpull="git fetch && git merge"
alias gst="git status"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gam="git commit --amend --no-edit"
alias gco="git checkout"
__git_complete gco _git_checkout
alias gbdiff="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias delorig="gst | grep '.orig$' | tr -s [:space:] ' ' | tr -s [:space:] '\n' | grep '.orig$' | xargs rm -v"
alias ynstall="rm -rf ./node_modules && yarn install --no-lockfile"
alias start="yarn start:bole:mocks --no-debug"
alias grh="git reset HEAD"

function gbranch {
  if [ -z "$1" ]; then
    git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
  elif [ "--remote" = "$1" ]; then
    git branch -r --list $2 --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
  elif [ "--author" = "$1" ]; then
    git branch -r --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' -r | grep $2
  fi
}

function lastCommit {
  for file in *; do 
    log=$(git log -n 2 --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' -- $file)
    echo -e "$file\t$log"
  done
}

function greset {
  FILE=$1
  if [ "$FILE" -eq "umd" ]; then
    git reset HEAD /umd/* && git checkout /umd/*
    exit 0;
  fi
  git reset HEAD "$@"
  git checkout "$@"
}


