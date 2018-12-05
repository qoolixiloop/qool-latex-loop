#!/bin/bash
helloworld() {
  local friend="$1"
  if [[ "$friend" == 'yes!' ]]; then
    echo "hello, my dear friends!"
  fi
}
helloworld "$@"

