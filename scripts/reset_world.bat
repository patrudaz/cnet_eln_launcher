mkdir ..\tmp\SIn_world
cd ..\tmp\SIn_world
tar -xf ../SIn_2022-20231120-162410.zip
cd ..
robocopy SIn_world "..\.minecraft\saves\SIn_world" /E /it /is
pause