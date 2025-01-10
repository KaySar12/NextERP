#!/bin/bash

# Get the current branch name
branch_name=$(git rev-parse --abbrev-ref HEAD)

# Get a list of all virtual environments, filtering out duplicates
virtualenvs=$(pyenv virtualenvs | awk '{print $1}' | sort -u)

# Loop through each virtual environment and delete it if it contains the branch name
for venv in $virtualenvs; do
  if [[ "$venv" == *"$branch_name"* ]]; then
    echo "Deleting virtual environment: $venv"
    pyenv virtualenv-delete "$venv" -f
  fi
done

echo "Virtual environments containing '$branch_name' deleted."