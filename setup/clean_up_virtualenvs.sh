#!/bin/bash

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Get a list of all virtual environments, filtering out duplicates and those not containing the branch name
virtualenvs=$(pyenv virtualenvs | awk '{print $1}' | sort -u | grep "$branch_name")

# Count the number of virtual environments
count=$(echo "$virtualenvs" | wc -l)

# Calculate how many virtual environments to keep
keep_count=$((count - $1))

# If there are more than 3 virtual environments, delete the oldest ones
if (( keep_count > 0 )); then
  # Get the oldest virtual environments (assuming they are listed first)
  oldest_venvs=$(echo "$virtualenvs" | head -n "$keep_count")

  # Loop through the oldest virtual environments and delete them
  for venv in $oldest_venvs; do
    echo "Deleting virtual environment: $venv"
    pyenv virtualenv-delete "$venv" -f
  done
fi

echo "Old virtual environments containing '$branch_name' deleted."