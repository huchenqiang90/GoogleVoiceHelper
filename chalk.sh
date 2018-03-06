#!/usr/bin/env bash

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
      -bk|-black)
        echo -ne "$BLACK"
      ;;
      -r|-red)
        echo -ne "$RED"
      ;;
      -g|-green)
        echo -ne "$GREEN"
      ;;
      -yl|-yellow)
        echo -ne "$YELLOW"
      ;;
      -b|-blue)
        echo -ne "$BLUE"
      ;;
      -pl|-purple)
        echo -ne "$PURPLE"
      ;;
      -cy|-cyan)
        echo -ne "$CYAN"
      ;;
      -wt|-white) 
        echo -ne "$WHITE"
      ;;
      -gy|-gray) 
        echo -ne "$NORMAL"
      ;;
      -h|--help)
        echo "Chalk is a colorful extension of echo"
        echo 
        echo "Usage: chalk -color1 message1 -color2 message2 ..."
        echo "   eg: chalk -red message_1 [ -blue message2 ]"
        echo 
        echo -n "colors: "
        $0 -black "black|bk " -red "red|r " -green "green|g " -yellow "yellow|y " -blue "blue|b "
        $0 "        " -purple "purple|pl " -cyan "cyan|cy " -white "white|wt " -gray "gray|gy "
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
