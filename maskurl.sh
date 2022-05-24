#!/bin/bash
# Author: Haitham Aouati

# Foreground colors
fg_black=$'\e[0;30m'
fg_red=$'\e[0;31m'                     
fg_green=$'\e[0;32m'
fg_yellow=$'\e[0;33m'
fg_blue=$'\e[0;34m'                    
fg_purple=$'\e[0;35m'                          
fg_cyan=$'\e[0;36m'         
fg_gray=$'\e[0;90m'
                                                                                      
red=$'\e[0;91m'
green=$'\e[0;92m'
yellow=$'\e[0;93m'                        
blue=$'\e[0;94m'
purple=$'\e[0;95m'               
cyan=$'\e[0;96m'
white=$'\e[0;37m'
                                                        
# Background colors                           
bg_red=$'\e[0;41m'

# ANSI formats
reset=$'\e[0m'
bold=$'\e[1m'
faint=$'\e[2m'
italics=$'\e[3m'
underline=$'\e[4m'

# Check root superuser

if (( $EUID == 0 )); then
    echo "Please do not run as root."
    exit
fi

clear

# Banner

cat << "EOF"
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⡿⠋⠀⠀⠀⠈⢻⣿⣿⠟⠁⠀⠀⠀⠙⣿⣿⣿⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⢈⣿⣿⠀⠀⠀⠀⠀⠀⢸⣿⣿⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣿⣿⣷⣄⠀⠀⠀⢀⣼⣿⣿⣧⡀⠀⠀⠀⣠⣿⣿⣿⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠻⠿⣿⣿⣿⣶⣿⣿⠿⠛⠛⠿⣿⣷⣶⣿⣿⣿⠿⠟⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⠏⢠⣶⠛⠛⣶⡄⠹⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠀⣿⠋⠑⠊⠙⣿⠀⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠲⠾⠷⠖⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣈⣀⣀⣀⣀⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣈⣉⣉⣉⣉⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉
EOF


# Script info

echo -e "$reset$bold            MaskURL$reser\n"
echo -e "$reset Author:$fg_blue Haitham Aouati"
echo -e "$reset Version:$fg_yellow 1.1 $white\n"
echo -e "$reset Repo: https://github.com/haithamaouati/maskurl\n"

# Check url

url_checker() {
    if [ ! "${1//:*}" = http ]; then
        if [ ! "${1//:*}" = https ]; then
            echo -e "\n$red[!]$reset Invalid URL. Please use http or https.\n"
            exit 1
        fi
    fi
}

read -p "URL $green(HTTP/HTTPS)$reset: " phish
url_checker $phish

short=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${phish})
shorter=${short#https://}

echo -e "\n$yellow[*]$reset Masking URL...\n"

read -p "URL Mask $green(HTTP/HTTPS)$reset: " mask
url_checker $mask

read -p "Words $yellow(index-home online-download): $reset" words
echo -e "\n$yellow[*]$reset Generate masked link...\n"

if [[ -z "$words" ]]; then
    echo -e "$red[!]$reset No words.\n"
    final=$mask@$shorter
    echo -e "$green[✓]$reset Masked URL:$fg_blue ${final}\n"
    exit
fi

if [[ "$words" =~ " " ]]; then
    echo -e "$red[!]$reset Invalid words. Please avoid space."
    final=$mask@$shorter
    echo -e "$green[✓]$reset Masked URL:$fg_blue ${final}\n"
    exit
fi

final=$mask-$words@$shorter
echo -e "$green[✓]$reset Masked URL:$fg_blue ${final}\n"
