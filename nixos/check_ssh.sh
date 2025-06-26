#!/bin/bash

# Check if there are any active SSH sessions for any user
if pgrep sshd > /dev/null; then
  echo "Active SSH sessions detected. System cannot sleep."
  exit 1
else
  echo "No active SSH sessions found. System can sleep."
  exit 0
fi
