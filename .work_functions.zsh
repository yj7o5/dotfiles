# for running active locally:w
#export PATH="/usr/local/opt/mysql@5.6/bin:$PATH"
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#npm config set prefix $NVM_DIR/versions/node/v10.13.0

function jopen {
  if [ "$#" -ne 1 ]; then
    echo "Usage: jopen CR-958178"
    echo " this attempts to open the url https://jira.cfdata.org/browse/CR-958178"
  else
    url="https://jira.cfdata.org/browse/$1"
    echo "opening ${url}"
    open "$url"
  fi
}

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

# helpful util for jumping into cf project wrapped in tmux
function prj_helper {
  starting_dir=$(pwd)

  local base=$HOME/cloudflare
  if [ ! -d "$base" ]; then
    echo "creating $base"
    mkdir $base
  fi
  local team=$1
  local project=$2
  local team_dir=$base/$team
  local project_dir=$base/$team/$project
  # echo "project_dir: $project_dir\nteam_dir: $team_dir"
  if [ ! -d $project_dir ]; then
    # check if project exists on bitbucket
    repo_url="ssh://git@bitbucket.cfdata.org:7999/$team/$project.git"

    # Try cloning the repository
    git ls-remote "$repo_url" > /dev/null 2>&1

    if [[ $? -eq 0 ]]; then
      echo "INFO: checking for $team_dir"
      if [ ! -d $team_dir ]; then
        echo "INFO: creating directory $team_dir"
        mkdir -p $team_dir
      fi

      echo "INFO: cloning $repo_url into $project_dir"
      git clone ssh://git@bitbucket.cfdata.org:7999/$team/$project.git $project_dir
    else
      echo "ERROR: project $repo_url does not exist in bitbucket"
      return 1
    fi
  fi

  # tmux is not running
  tmux_running=$(pgrep tmux)
  if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
      tmux new-session -s $project -c $project_dir
      exit 0
  fi

  if ! tmux has-session -t="$project" 2>/dev/null; then
      echo "creating session $project with root dir at $(pwd)"
      tmux new-session -d -s "$project" -c "$project_dir"
  fi

  if [[ -z $TMUX ]]; then
    # we aren't in tmux, so attach to new session
    tmux attach-session -t "$project" -c "$project_dir"
  else
    # we're already in tmux, so switch to new session
    tmux switch-client -t "$project"
  fi

  # Check if the function failed
  if [[ $? -ne 0 ]]; then
    cd $starting_dir
    return 1
  fi
}

function dev {
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

function enable_sfo_dog_proxy {
  sudo warp-cli tunnel endpoint set '162.159.204.1:2408' > /dev/null
  warp-cli tunnel rotate-keys > /dev/null
  sleep 1
  curl -so - https://cloudflare.com/cdn-cgi/trace | grep '^colo=\|^sliver=\|^fl='
}

function disable_sfo_dog_proxy  {
  sudo warp-cli tunnel endpoint reset > /dev/null
  sleep 1
  curl -so - https://cloudflare.com/cdn-cgi/trace | grep '^colo=\|^sliver=\|^fl='
}

export JAVA_HOME=$HOME/OpenJDK/jdk-22.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jevans/Desktop/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jevans/Desktop/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jevans/Desktop/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jevans/Desktop/google-cloud-sdk/completion.zsh.inc'; fi

# needed with latest docker engine
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_DEFAULT_PLATFORM=linux/arm64

# private CF npm registry
# https://wiki.cfdata.org/display/FE/Getting+started+with+the+private+NPM+registry
export NPM_TOKEN=$(cloudflared access login --no-verbose https://registry.cloudflare-ui.com)

# Accessing Vault
export VAULT_CACERT=/etc/ssl/certs/cfks.crt
alias vault-fed="VAULT_ADDR=https://fed.vault.cfdata.org:8200 vault $@"
