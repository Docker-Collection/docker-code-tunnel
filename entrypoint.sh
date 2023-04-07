#!/bin/bash

# Change Password if is exist

if [ -n "$SUDO_PASSWORD" ]; then
  echo "Setup ubuntu password"
  echo -e "${SUDO_PASSWORD}\n${SUDO_PASSWORD}" | passwd
  echo ""
else
  echo "No Sudo Password setup"
  echo ""
fi

pid=0

term_handler() {
  if [ "$pid" -ne 0 ]; then
    kill -SIGTERM "$pid"
    wait "$pid"
  fi
  # exit 143;
}

trap 'kill ${!}; term_handler' TERM

code tunnel --accept-server-license-terms &
pid="$!"

# Wait for the child process to exit
wait "$pid"

# Exit with the child process's exit status
exit $?
