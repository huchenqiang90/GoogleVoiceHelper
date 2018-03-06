#!/usr/bin/env bash

timeto(){
  local SCRIPTNAME=${0##*/}
  local from=0
  local to=0
  local seconds=0
  local relative=false
  local humanize=false
  
  local minute=60
  local hour=$((minute * 60))
  local day=$((hour * 24))
  local month=$((day * 30))
  local year=$((month * 12))
  local const=($year $month $day $hour $minute)
  local unit=('year' 'month' 'day' 'h' 'min' 'S')
  local duration=(0 0 0 0 0)
  
  show_help(){
    cat <<-END
		display passed seconds to more friendly time format

		Usage: 
		  timeto [second] [OPTION]...
		  timeto second
		  timeto second -h
		  timeto -f start -t end
		  `timeto second` == `timeto -f 0 -t second``

		Options:
		  -f, --from            from relative start moment, second, 0 is default
		  -t, --to              to the relative end moment, second, 0 is default
		  -h, --humanize        print duration in human readable format 
		                        (e.g., a few seconds, 2 minutes, 4 hours)
		END
  }

  local ARGS=`getopt -n $SCRIPTNAME -o f:t:h -l from:,to:,humanize,help -- "$@"`
  if [ $? -ne 0 ]; then show_help; exit 1; fi
  eval set -- $ARGS

  while true ; do
    case "$1" in
      -f|--from) relative=true; from="$2"; shift 2;;
      -t|--to) relative=true; to="$2"; shift 2;;
      -h|--humanize) humanize=true; shift;;
      --help) show_help; exit 1;;
      --) shift; break;;
      *) echo "timeto: unknown option $1, plase check usage in help: \`$SCRIPTNAME --help\`"; exit 1;;
    esac
  done

  if $relative; then
    if (($# > 0)); then
      echo "timeto: Too many arguments while use relative mode!"
      exit 1
    else 
      seconds=$((to - from))
    fi
  else 
    seconds=${1:-0}
  fi

  local index=0
  for item in ${const[@]}; do
    duration[$index]=$((seconds / item))
    let seconds%=item
    let index++
  done

  duration=(${duration[@]} $seconds)

  local elapse=""

  index=0
  for item in ${duration[@]}; do
    if [ $item -gt 0 ]; then
      elapse="${item}${unit[$index]}"
      let local next=index+1
      if [ $next -lt ${#duration[@]} -a ${duration[$next]:-0} -gt 0 ]; then
        let local next=index+1
        elapse="${elapse} ${duration[$next]}${unit[$next]}"
      fi
      break
    fi
    let index++
  done

  echo "${elapse:-0S}"
}

if [ $# != 0 ]; then
  timeto "$@"
fi
