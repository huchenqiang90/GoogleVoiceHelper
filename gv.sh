#!/bin/bash

load(){
  # Usage: load filename parameter
  local file="$1"
  shift
  . "$file"
}


load chalk.sh
load timeto.sh

GV_CURL_FILE='gv-curl'
GV_NUMBER_FILE='gv-number'
placeholder='0123456789'
ERROR_REQ='[[null,null,"There was an error with your request. Please try again."]]'

if [ -r "$GV_CURL_FILE" ]; then
  gv_curl=`cat "$GV_CURL_FILE"`
else
  echo "input google vioce setting post cURL(bash)"
  read gv_curl
  echo
  gv_curl=${gv_curl/"zh-CN,zh"/"en-US,en"}
  gv_curl=${gv_curl/"mid=2"/"mid=6"}
  gv_curl=${gv_curl/"true%5D"/"%22%2B1${placeholder}%22%2Ctrue%2C%22%22%5D"}
  echo "$gv_curl -s" > "$GV_CURL_FILE"
fi


if [ $# != 0 ]; then
  gv_num="$1"
  gv_num=$(echo "$gv_num" | tr -cd '[0-9]')
  if [ ! -r "$GV_NUMBER_FILE" ]; then
    echo "$gv_num" > "$GV_NUMBER_FILE"
  fi
else
  if [ -r "$GV_NUMBER_FILE" ]; then
    gv_num=`cat "$GV_NUMBER_FILE"`
  else
    echo "input gv number, eg: '0123456789' or '(012) 345-6789'"
    read gv_num
    echo
    gv_num=$(echo "$gv_num" | tr -cd '[0-9]')
    echo "$gv_num" > "$GV_NUMBER_FILE"
  fi
fi

gv_curl=${gv_curl/"%2B1${placeholder}%22"/"%2B1${gv_num}%22"}


begin_time=`date +%s`

for (( i=1; i>0; i++ ))
do
  chalk -n "[`date +'%Y-%m-%d %H:%M:%S'`] " -white "#$i " -gray "try to submit post...  "
  if [ "$(eval $gv_curl)" != "$ERROR_REQ" ]; then
    cost_time=timeto $((`date +%s` - begin_time))
    chalk " - " -yellow "END."
    chalk
    chalk "NOT known that " -green "successed" -gray " or " -red "failed" \
          -gray ", plz check your gmail."
    chalk "totallt tried " -green "$i" -gray " times, and costed " -green "${cost_time}."
    exit 0
  else
    cost_time=$((`date +%s` - begin_time))
    cost_time=$(timeto $cost_time)
    echo "cost_time $cost_time"
    chalk " - " -red "failed. " -gray "[pass ${cost_time}]"
  fi
  sleep 0.6s
done
