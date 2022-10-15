# for running active locally:w
#export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#npm config set prefix $NVM_DIR/versions/node/v10.13.0

# helpful util for jumping into sbt REPL
function prj {
  local base=$HOME/discord
  if [ ! -d "$base" ]; then
    mkdir $base
  fi
  local project=$1
  local project_dir=$base/$project
  if [ ! -d "$project_dir" ]; then
    cd $base && git clone git@github.com:discord/$project.git
  fi

  cd $project_dir
}

_prj() {
    local cur opts
    cur="${COMP_WORDS[COMP_CWORD]}"
    opts=$(cd $HOME/discord ; ls)
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
  prj discord
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
