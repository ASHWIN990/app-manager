#!/usr/bin/env bash

#Tool = app-manager installer
#Version = 0.1
#Author = ASHWINI SAHU
#GitHub = ASHWIN990
#Date = 12/10/2022
#Written in Bash

set -euo pipefail

function install() {

    if [ "$1" == "file" ]; then
        echo -e "Installing from the existing file"
        echo -e "File path : $PWD/app-manager"
    elif [ "$1" == "internet" ]; then
        echo -e "Installing from the internet"
        echo -e "URL : https://raw.githubusercontent.com/ASHWIN990/app-manager/main/app-manager"
    fi

    if [ ! -d "$HOME/.local/bin/" ]; then
        mkdir -p "$HOME/.local/bin/"
    fi

    if [ "$(command -v app-manager)" ]; then

        message=$(echo -e "\napp-manager already installed in $(command -v app-manager)\nInstall it anyway : (Y/n) ? : ")
        read -rp "$message" yn

        case $yn in
        [Nn]*)
            echo -e "\nAborting the installation !"
            exit 0
            ;;
        esac
    fi

    if [ "$1" == "internet" ]; then
        echo "Downloading the app-manager" && wget -q "https://raw.githubusercontent.com/ASHWIN990/app-manager/main/app-manager"
    fi

    chmod +x "$PWD/app-manager"
    cp "$PWD/app-manager" "$HOME/.local/bin/"
    echo -e "\nInstallation done succesfully in $(command -v app-manager)"
}

if [ -e app-manager ]; then
    install "file"
else
    install "internet"
fi
