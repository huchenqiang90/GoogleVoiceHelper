#!/bin/bash

chalk(){
  local NORMAL="\033[0m"
  local BLACK="\033[30;1m"
  local RED="\033[31;1m"
  local GREEN="\033[32;1m"
  local YELLOW="\033[33;1m"
  local BLUE="\033[34;1m"
  local PURPLE="\033[35;1m"
  local CYAN="\033[36;1m"
  local WHITE="\033[37;1m"
  local nowarp=""

  for var in "$@"
  do
    case "$var" in
      -black)
        echo -ne "$BLACK"
      ;;
      -red)
        echo -ne "$RED"
      ;;
      -green)
        echo -ne "$GREEN"
      ;;
      -yellow)
        echo -ne "$YELLOW"
      ;;
      -blue)
        echo -ne "$BLUE"
      ;;
      -purple)
        echo -ne "$PURPLE"
      ;;
      -cyan)
        echo -ne "$CYAN"
      ;;
      -white) 
        echo -ne "$WHITE"
      ;;
      -gray) 
        echo -ne "$NORMAL"
      ;;
      -h|-help|--help)
        echo "Chalk is a colorful extension of echo"
        echo "Version 0.0.3"
        echo "Usage: chalk -color1 message1 -color2 message2 ..."
        echo "eg:    chalk -red message_1 [ -blue message2 ]"
        echo -n "colors: "
        $0 -black "black " -red "red " -green "green " -yellow "yellow "\
          -blue "blue " -purple "purple " -cyan "cyan " -white "white " -gray "gray "
        exit 0
      ;;
      -n|--nowarp)
        nowarp="-n"
      ;;
      *)
        echo -ne "$var"
      ;;
    esac
  done
  echo $nowarp -e "$NORMAL"
}

if [ $# != 0 ]; then
  chalk "$@"
fi
