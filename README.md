# CNet ELN Launcher

This project contains the source code of the ELN Launcher used in the CNet lab.

It is composed of a simple GUI that acts as a Minecraft launcher. There are three buttons : 
- Launch Game : Run a script that launch the game with the parameters selected.
- Reset Map : If the map is corrupted for any reason, it will erase and replace it with a fresh new one.
- Options : Brings up a configuration window that allows you to choose different parameter values.

The minecraft client and scripts related were created using [HCML](https://hmcl.huangyuhui.net/download). The game was configured to have Forge installed.

Two mods are installed, OpenComputers and ElectricalAge. Opencomputers is the one that was available in the previous lab version.

For ElectricalAge it's a bit different. Every time a release of this launcher is created, the latest version of the mod is pulled from [this repository](https://github.com/axalppro/ElectricalAge/) and incorporated in the game files.

## Table of Contents

- [Installation](#installation)
- [Contributing](#for-contributors)

## Installation

1. Go to the [release page](https://github.com/axalppro/cnet_eln_launcher/releases).
2. Download the latest release.zip available.
3. Extract the .zip downloaded.
4. Execute cnet_launcher.exe.

## For contributors

A release will be created every time a tag is pushed on the repository.
A Github workflow action will be triggered, it then launches a Windows container, checkout this repository, install some tools and setup the Python environment.
Then it downloads the latest version of the mod and adds it to the game files.
Finally it compiles the Python project into a .exe file using PyInstaller and creates a release.

Here is an overview of the different components involved : 

![ELN Launcher Components](/doc/overview.png)

