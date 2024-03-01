@echo off

SET F="..\.minecraft\saves\SIn_world\"
if exist %F% RMDIR /S /Q %F%

mkdir %F%
cd /d %F%
tar -xf "..\SIn_world-20231122.zip"
echo "Map reset successfully !"