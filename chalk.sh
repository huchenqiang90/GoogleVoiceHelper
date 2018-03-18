#!/usr/bin/env bash

chalk() {
  local NORMAL=`tput sgr0`
  local BLACK=`tput setaf 0`
  local RED=`tput setaf 1`
  local GREEN=`tput setaf 2`
  local YELLOW=`tput setaf 3`
  local BLUE=`tput setaf 4`
  local MAGENTA=`tput setaf 5`
  local CYAN=`tput setaf 6`
  local WHITE=`tput setaf 7`

  local BRIGHT=`tput bold`
  local UNDERLINE=`tput smul`
  local OFFUNDERLINE=`tput rmul`
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
      -mag|-magenta)
        echo -ne "$MAGENTA"
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
      -bright) 
        echo -ne "$BRIGHT"
      ;;
      -under) 
        echo -ne "$UNDERLINE"
      ;;
      -h|--help)
        echo "Chalk is a colorful extension of echo"
        echo 
        echo "Usage: chalk -color1 message1 -color2 message2 ..."
        echo "   eg: chalk -red message_1 [ -blue message2 ]"
        echo 
        echo -n "colors: "
        $0 -black "black|bk " -red "red|r " -green "green|g " -yellow "yellow|y " -blue "blue|b "
        $0 "        " -magenta "magenta|mag " -cyan "cyan|cy " -white "white|wt " -gray "gray|gy "
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
