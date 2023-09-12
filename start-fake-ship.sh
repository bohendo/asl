#!/usr/bin/env bash

name="${1:-zod}"
root=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )
data="$root/data"
fresh="fresh-$name"
reset="${2:-"false"}" # or "true" to reset all persistent data to fresh state
ames_port="$((8000 + RANDOM % 1000))"
http_port="$((8000 + RANDOM % 1000))"

if [[ "$1" == "--reset" ]]
then reset="true"
fi

if [[ -n "$(command -v urbit)" ]]
then
  echo "Starting urbit via local binary at $(realpath "$(which urbit)")"
  urbit="$(realpath "$(which urbit)")";
elif [[ -n "$(command -v docker)" ]]
then
  image_name="tloncorp/vere"
  image_version="v2.4"
  image="$image_name:$image_version"
  if ! grep -q "$image_version" <<<"$(docker image ls | grep "$image_name")"
  then docker image pull "$image"
  fi
  urbit="docker run --interactive --tty --rm --name=$name --mount=type=bind,src=$data,dst=/urbit --publish=8080:80 --entrypoint=urbit $image --loom 31"
else
  echo "Neither urbit nor docker is installed, can't start a fake ship" && exit 1
fi

mkdir -p "$data"
cd "$data" || exit 1
if [[ -d "$fresh" ]]
then
  if [[ ! -d "$name" ]]
  then
    echo "Copying fresh data from $fresh to $name"
    sudo chown -R "$(whoami)" .
    cp -r "$fresh" "$name"
  elif [[ "$reset" == "true" ]]
  then
    echo "Deleting all data for $name"
    sleep 3 # give user a sec to ctrl-c if this was a mistake
    sudo chown -R "$(whoami)" .
    rm -rfv "$name"
    cp -r "$fresh" "$name"
  fi
  $urbit --ames-port="$ames_port" --http-port="$http_port" "$name"
else
  echo
  echo "No data found at $(realpath $fresh)"
  echo "Booting a new urbit (+ dev-latest.pill) to use as a quick-start $name.."
  echo "Once this ship boots, run the following commands to pre-configure the fresh data dir"
  echo "~$name:dojo> |mount %base" # generic boilerplate (like what you get after `git init`)
  echo "~$name:dojo> |mount %garden" # this desk serves landscape so the server I guess?
  echo "~$name:dojo> |mount %landscape" # landscape gui I think
  echo "~$name:dojo> |mount %webterm" # in-browser dojo terminal app
  echo "~$name:dojo> |exit"
  echo "Then, re-run this script to start a fresh $name ship from the generated fresh"
  echo
  sleep 3 # give the user a sec to read the message above
  pill="dev-latest.pill"
  if [[ ! -f "$pill" ]]
  then
    echo "Downloading $pill"
    wget https://storage.googleapis.com/media.urbit.org/developers/dev-latest.pill
  fi
  $urbit --fake "$name" --bootstrap "$pill" --pier "$fresh" # warning: takes ~2 minutes & lots of cpu
fi
