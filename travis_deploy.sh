#!/bin/bash
if [ -n "$GITHUB_API_KEY" ]; then
  echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

  # Build the project.
  hugo # if using a theme, replace by `hugo -t <yourtheme>`

  # Go To Public folder
  cd public
  # Add changes to git.
  git add -A

  # Commit changes.
  msg="rebuilding site `date`"
  if [ $# -eq 1 ]
    then msg="$1"
  fi
  git commit -m "$msg"

  # Push source and build repos.
  git push -f -q https://jose-villegas:$GITHUB_API_KEY@github.com/jose-villegas/jose-villegas.github.io.git master

  # Come Back
  cd ..
fi