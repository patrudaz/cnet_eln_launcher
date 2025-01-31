#!/usr/bin/env bash

exec >> sh_log_cnet.txt

if [ -d ../.minecraft/saves/CNet_world ]; then
  rm -R ../.minecraft/saves/CNet_world
fi

mkdir ../.minecraft/saves/CNet_world
cd ../.minecraft/saves/CNet_world

zipfile=$(ls -t ../*.zip | head -1)

if [ -n "$zipfile" ]; then
  unzip "$zipfile"
  echo "Map reset successfully !"
else
  echo "No ZIP file found in parent directory."
fi
