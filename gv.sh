#!/usr/bin/env bash

. loader.sh
load chalk.sh
load timeto.sh
load daemon.sh


interval=0.5s
daemon=false
SCRIPTNAME=${0##*/}
GV_CURL_FILE='gv-curl'
GV_NUMBER_FILE='gv-number'
PLACEHOLDER='GV-NUMBER-PLACEHOLDER'
ERROR_RES='[[null,null,"There was an error with your request. Please try again."]]'
ERROR_500='<HTML>
<HEAD>
<TITLE>Internal Server Error</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF" TEXT="#000000">
<H1>Internal Server Error</H1>
<H2>Error 500</H2>
</BODY>
</HTML>'

show_help() { cat README.md; }
ARGS=`getopt -n $SCRIPTNAME -o t:dh -l time:,daemon,help -- "$@"`

if [ $? -ne 0 ]; then
    show_help
    exit 1
fi

eval set -- $ARGS

while true ; do
  case "$1" in
    -t|--time) interval="$2"; shift 2;;
    -d|--daemon) daemon=true; shift;;
    -h|--help) show_help; exit 1;;
    --) shift; break;;
    *) echo "unknown option $1, plase check usage in help: \`$SCRIPTNAME --help\`"; exit 1;;
  esac
done


if [ -r "$GV_CURL_FILE" ]; then
  gv_curl=`cat "$GV_CURL_FILE"`
else
  echo
  echo "input google vioce setting post cURL(bash)"
  read gv_curl
  echo
  gv_curl=${gv_curl/"zh-CN,zh"/"en-US,en"}
  gv_curl=${gv_curl/"mid=2"/"mid=6"}
  gv_curl=${gv_curl/"%2Ctrue%5D"/"%2C%22%2B1${PLACEHOLDER}%22%2Ctrue%2C%22%22%5D"}
  gv_curl="$gv_curl -s"
  echo "$gv_curl" > "$GV_CURL_FILE"
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
    echo
    echo "input gv number, eg: '0123456789' or '(012) 345-6789'"
    read gv_num
    echo
    gv_num=$(echo "$gv_num" | tr -cd '[0-9]')
    echo "$gv_num" > "$GV_NUMBER_FILE"
  fi
fi

gv_start() {
  chalk "\n" -wt "[`date +'%Y-%m-%d %H:%M:%S'`] " -gy "GV Helper start, apply for number " -wt "${gv_num}"

  begin_time=`date +%s`
  gv_curl=${gv_curl/"${PLACEHOLDER}"/"${gv_num}"}
  for (( i=1; i>0; i++ )); do
    chalk -n "[`date +'%Y-%m-%d %H:%M:%S'`] " -wt "#$i " -gy "submit post with num ${gv_num}..."
    response="$(eval $gv_curl)"
    cost_time=$((`date +%s` - begin_time))
    cost_time=$(timeto $cost_time)
    if [ "$response" == "$ERROR_RES" ]; then
      chalk " - " -r "failed. " -gy "[running ${cost_time}]"
    elif [ "$response" == "$ERROR_500" ]; then
      chalk " - " -r "500 - Internal Server Error." -gy "[running ${cost_time}]"
    else
      chalk " - " -yl "END. " -gy "[running ${cost_time}]"
      chalk -wt "Endding response is: " -gy "[$response]"
      chalk
      chalk "NOT known that " -g "successed" -gy " or " -r "failed" \
            -gray ", plz check your gmail."
      chalk "total tried " -g "$i" -gy " times, and costed " -g "${cost_time}."
      exit 0
    fi
    sleep "$interval"
  done
}

if $daemon; then
  logfile="gv-${gv_num}.log"
  chalk "GV helper is run in daemon mode, and the log is save to " -wt "$logfile"
  daemonify gv_start "$logfile"
else
  gv_start
fi
