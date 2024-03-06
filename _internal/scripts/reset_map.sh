#!/bin/sh

exec >> sh_log_cnet.txt

if [ -d ../.minecraft/saves/SIn_world ]; then
  rm -R ../.minecraft/saves/SIn_world
fi

mkdir ../.minecraft/saves/SIn_world
cd ../.minecraft/saves/SIn_world

zipfile=$(ls -t ../*.zip | head -1)

if [ -n "$zipfile" ]; then
  unzip "$zipfile"
  echo "Map reset successfully !"
else
  echo "No ZIP file found in parent directory."
fi
