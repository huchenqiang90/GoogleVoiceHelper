#!/bin/bash

timeto(){
  local minute=60
  local hour=$((minute * 60))
  local day=$((hour * 24))
  local month=$((day * 30))
  local year=$((month * 12))
  local const=($year $month $day $hour $minute)
  local unit=('year' 'month' 'day' 'hour' 'min' 'S')
  local duration=(0 0 0 0 0)
  local seconds=$1

  local index=0
  for i in ${const[@]}; do
    duration[$index]=$((seconds / i))
    let seconds%=i
    let index++
  done

  duration=(${duration[@]} $seconds)

  local elapse=""

  index=0
  for item in ${duration[@]}; do
    if [ $item -gt 0 ]; then
      elapse="${item} ${unit[$index]}"
      let local next=index+1
      if [ $next -lt ${#duration[@]} -a ${duration[$next]:-0} -gt 0 ]; then
        let local next=index+1
        elapse="${elapse} ${duration[$next]} ${unit[$next]}"
      fi
      break
    fi
    let index++
  done

  echo "${elapse:-0}"
}

if [ $# != 0 ]; then
  timeto "$@"
fi
