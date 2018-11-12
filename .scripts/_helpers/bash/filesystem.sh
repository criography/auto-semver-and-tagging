#!/bin/bash


# fun: get_current_dir
# txt: Get running script's directory
# use: get_current_dir
get_current_dir() {
  echo "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
}
