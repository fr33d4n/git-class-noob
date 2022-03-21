echo 'Loading VM console...';

source ~/.git-completion.bash
source ~/.git-prompt.sh

# Thy holy prompt.
PROMPT_COMMAND='PS1="${c_time}\D{%T} ${c_time}${c_user}\u${c_reset}@${c_user}\h${c_reset}:${c_path}\w${c_reset}$(git_prompt)\$ "'

# Git aliases
alias gst="git status"
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gam="git commit --amend --no-edit"
alias gco="git checkout"

function gbranch {
  if [ -z "$1" ]; then
    git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
  elif [ "--remote" = "$1" ]; then
    git branch -r --list $2 --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'
  elif [ "--author" = "$1" ]; then
    git branch -r --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))' -r | grep $2
  fi
}


