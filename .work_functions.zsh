# for running active locally:w
#export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#npm config set prefix $NVM_DIR/versions/node/v10.13.0

function ff {
  result=$(rg --ignore-case --color=always --line-number --no-heading "$@" |
    fzf --ansi \
        --color 'hl:-1:underline,hl+:-1:underline:reverse' \
        --delimiter ':' \
        --preview "bat --color=always {1} --theme='Solarized (light)' --highlight-line {2}" \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
  file=${result%%:*}
  linenumber=$(echo "${result}" | cut -d: -f2)
  if [[ -n "$file" ]]; then
          $EDITOR +"${linenumber}" "$file"
  fi
}

# helpful util for jumping into sbt REPL
function prj {
  local base=$HOME/cloudflare
  if [ ! -d "$base" ]; then
    echo "creating $base"
    mkdir $base
  fi
  local team=$1
  local team_dir=$base/$team
  if [ ! -d "$team_dir" ]; then
    echo "creating $team_dir"
    mkdir -p $team_dir
  fi
  local project=$2
  local project_dir=$base/$team/$project
  echo "project_dir: $project_dir\nteam_dir: $team_dir"
  if [ ! -d "$project_dir" ]; then
    echo "cloning $project into $team_dir"
    cd $team_dir && git clone ssh://git@bitbucket.cfdata.org:7999/$team/$project.git
  fi

  cd $project_dir
}

_prj() {
    local cur opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$(cd $HOME/cloudflare ; ls)
    COMPREPLY=($(compgen -W "${opts}" -- ${cur}))
}
complete -F _prj prj

#compdef clyde
_clyde() {
  eval $(env COMMANDLINE="${words[1,$CURRENT]}" _CLYDE_COMPLETE=complete-zsh  clyde)
}
if [[ "$(basename -- ${(%):-%x})" != "_clyde" ]]; then
  compdef _clyde clyde
fi

function dev {
  prj cloudflare
  tmux new-session -d
  tmux split-window -h
  tmux split-window -v
  tmux -2 attach-session -d
}

### PROCESS
# mnemonic: [K]ill [P]rocess
# show output of "ps -ef", use [tab] to select one or multiple entries
# press [enter] to kill selected processes and go back to the process list.
# or press [escape] to go back to the process list. Press [escape] twice to exit completely.
function kp {
  local pid=$(ps -ef | sed 1d | eval "fzf ${FZF_DEFAULT_OPTS} -m --header='[kill:process]'" | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    echo $pid | xargs kill -${1:-9}
    kp
  fi
}
