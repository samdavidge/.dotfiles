# zshrc config file.
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

# Run: git config --global alias.clean-branch '!git_clean_branches'
git_clean_branches() {
  local force=false
  if [[ "$1" == "-f" ]]; then
    force=true
  fi

  git fetch --prune

  git branch -vv | grep '\[origin.*gone\]' | awk '{print $1}' | while read branch; do
  created=$(git log -1 --format=%ai "$branch" | cut -d' ' -f1)
  created_epoch=$(date -jf '%Y-%m-%d' "$created" +%s)
  now_epoch=$(date +%s)
  if [ $((now_epoch - created_epoch)) -gt 86400 ]; then
    if [ "$force" = true ]; then
      git branch -D "$branch"
    else
      echo "Would delete: $branch (created $created)"
    fi
  fi
done
}


# Prompt Formatting (https://misc.flogisoft.com/bash/tip_colors_and_formatting)
COLOR_DEF='%f'
COLOR_USR='%F{74}'
COLOR_DIR='%F{74}'
COLOR_GIT='%f'
NEWLINE=$'\n'
# Set zsh option for prompt substitution
setopt PROMPT_SUBST
export CLICOLOR=1
export PROMPT='${COLOR_USR}%n %f@ ${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch)${COLOR_DEF}${NEWLINE} ➡️ '

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

alias vim="nvim"
alias v="nvim"
alias sail="./vendor/bin/sail"
alias ai="gh copilot"
alias clean-branches='git_clean_branches'
