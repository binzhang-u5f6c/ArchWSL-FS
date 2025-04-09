#!/bin/bash

set -ue

DEFAULT_GROUPS='wheel'
DEFAULT_UID='1000'

echo 'Please create a default UNIX user account. The username does not need to match your Windows username.'
echo 'For more information visit: https://aka.ms/wslusers'

if getent passwd "$DEFAULT_UID" > /dev/null ; then
  echo 'User account already exists, skipping creation'
  exit 0
fi

while true; do

  # Prompt from the username
  read -p 'Enter new UNIX username: ' username

  # Create the user
  if /usr/sbin/useradd -m --uid "$DEFAULT_UID" "$username"; then
    /usr/sbin/passwd "$username"
    if /usr/sbin/usermod "$username" -aG "$DEFAULT_GROUPS"; then
      break
    else
      /usr/sbin/userdel "$username"
    fi
  fi
done
