@echo off

SET "F=..\.minecraft\saves\CNet_world\"
if exist "%F%" RMDIR /S /Q "%F%"

mkdir "%F%"
cd /d "%F%"

for %%i in ("..\*.zip") do (
    set "zipfile=%%i"
)

if defined zipfile (
    tar -xf "%zipfile%"
    echo "Map reset successfully !"
) else (
    echo No ZIP file found in parent directory.
)
