#!/usr/bin/env bash

load() {
  # Usage: load filename parameter
  # to isolate loader parameter from parent parameter
  local file="$1"
  shift
  . "$file"
}
