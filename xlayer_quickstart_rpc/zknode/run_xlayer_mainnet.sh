#!/bin/bash
set -e

BASEDIR=$(pwd)
WORKSPACE="$BASEDIR/mainnet"

download () {
    if command -v axel &> /dev/null; then
        axel -n 8 -o "$2" "$1"
    elif command -v curl &> /dev/null; then
        curl -L -o "$2" "$1"
    elif command -v wget &> /dev/null; then
        wget -O "$2" "$1"
    else
        echo "Error: curl or wget is not installed." >&2
        exit 1
    fi
}

# Check if Docker and Docker Compose are installed
check_dependencies() {
    if docker ps > /dev/null 2>&1; then
        echo "Docker daemon is running."
    else
        echo "Docker daemon is not running."
        exit 1
    fi
    if ! command -v docker-compose &> /dev/null; then
        echo "Error: Docker Compose is not installed." >&2
        exit 1
    fi
    echo "Docker and Docker Compose are installed."
}


function remote_out(){
    if command -v curl &> /dev/null; then
        curl "$1"
    elif command -v wget &> /dev/null; then
        wget -q -O - "$1"
    else
        echo "Error: curl or wget is not installed." >&2
        exit 1
    fi
}

function unpack() {
    if command -v pigz &> /dev/null; then
        tar --use-compress-program="pigz -d" -xf "$1"
    elif command -v tar &> /dev/null; then
        tar -zxf "$1"
    else
        echo "Error: tar or unzip is not installed." >&2
        exit 1
    fi
}

branch=${BRANCH:-"main"}
function download_init_file() {
  download https://raw.githubusercontent.com/okx/Deploy/"$branch"/xlayer_quickstart_rpc/zknode/run_xlayer_mainnet.sh run_xlayer_mainnet.sh && chmod +x run_xlayer_mainnet.sh
  download https://github.com/okx/Deploy/archive/refs/heads/"$branch".zip "$branch".zip
  unzip "$branch".zip
  mv Deploy-"$branch"/xlayer_quickstart_rpc/zknode/mainnet "$WORKSPACE"/
  rm -rf Deploy-"$branch" "$branch".zip
}

function download_do_restore() {
  rm -rf xlayer_mainnet_data
  latest_snap=$(remote_out https://static.okex.org/cdn/chain/xlayer/snapshot/mainnet-latest)
  download https://static.okex.org/cdn/chain/xlayer/snapshot/"$latest_snap" "$latest_snap"
  echo "unpacking snapshot: $latest_snap"
  tar -zvxf "$latest_snap"
  rm  "$latest_snap"
}

function find_url() {
    case $(uname -s) in
        *[Dd]arwin* | *BSD* ) sed -n 's/^XLAYER_NODE_ETHERMAN_URL[[:space:]]*=[[:space:]]*"\([^"]*\)"$/\1/p' ".env";;
        *) sed -n 's/^XLAYER_NODE_ETHERMAN_URL\s*=\s*"\([^"]*\)"$/\1/p' ".env";;
    esac
}

function check_l1_rpc() {
  url=$(find_url)
  if [[ -z "$url" ]]; then
    echo "L1 RPC URL is empty, please set XLAYER_NODE_ETHERMAN_URL env variable"
    exit 1
  fi
}

function init() {
  download_init_file
}


function restore() {
  cd "$WORKSPACE" || exit 1
  check_l1_rpc
  download_do_restore
  cd "$BASEDIR" || exit 1
}


function start() {
  cd "$WORKSPACE" || exit 1
  check_l1_rpc
  docker-compose --env-file .env -f ./docker-compose.yml up -d
  cd "$BASEDIR" || exit 1
}

function stop() {
  cd "$WORKSPACE" || exit 1
  check_l1_rpc
  docker-compose --env-file .env -f ./docker-compose.yml down
  cd "$BASEDIR" || exit 1
}

function update() {
  download_init_file
  cd "$WORKSPACE" || exit 1
  check_l1_rpc
  stop
  start
  cd "$BASEDIR" || exit 1
}

function help() {
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  init     Initialize the configuration."
    echo "  restore  Restore the system to a previous state."
    echo "  start    Start the rpc service."
    echo "  stop     Stop the rpc service."
    echo "  restart  Restart the rpc service."
    echo "  update   Update the rpc service to the latest version."
    echo ""
    echo "Examples:"
    echo "  $0 init"
    echo "  $0 restore"
    echo "  $0 start"
    echo "  $0 stop"
    echo "  $0 restart"
    echo "  $0 update"
}



function op() {
    case "$1" in
        "init")
            echo "####### init config #######"
            init
            ;;
        "restore")
            echo "####### restore #######"
            restore
            ;;
        "start")
            echo "####### rpc service start #######"
            start
            ;;
        "stop")
            echo "####### rpc service down #######"
            stop
            ;;
        "restart")
            echo "####### rpc service restart #######"
            stop
            start
            ;;
        "update")
            echo "####### rpc service update #######"
            update
            ;;
        *)
            echo "Unknown operation: $1"
            echo "[init, restore, start, stop, restart, update] flag are support!"
            ;;
    esac
}

check_dependencies
if [ $# -eq 0 ]; then
    help
else
    op "$1"
fi

