#!/run/current-system/sw/bin/bash -e
set -e
path=$(pwd)
while [[ $path != / ]];
do
    find "$path" -maxdepth 1 -mindepth 1 -iname "flake.nix"
    path="$(readlink -f "$path"/..)"
done
