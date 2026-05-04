#!/usr/bin/env bash
#
# Checks git for new secrets and ensures they exist in 1Password.
#

set -eou pipefail

# Run from the root of the repository
cd "$(dirname "$0")/../.."

diff=$(git diff --name-only HEAD^)
errors=0

for file in $diff; do
  if [[ ! "$file" == helm* ]]; then
    continue
  fi

  echo "==> $file"

  new_lines=$(git diff HEAD^ "$file" | grep ^+ | grep "op://" || echo)
  echo "$new_lines"

  IFS=$'\n'
  for line in $new_lines; do
    name=$(echo "$line" | cut -d: -f1 | tr -d '+' | awk '{print $1}')
    # Remove leading space and surrounding quotes from op:// path
    secret=$(echo "$line" | cut -d: -f2- | sed -e 's/^ //' -e 's/^"\(.*\)"$/\1/')
    echo "====> ${name}"
    result=$(op read $secret >/dev/null)
    if [[ $? -eq 0 ]]; then
      echo "OK"
    else
      errors=$((errors + 1))
    fi
  done
done

exit $errors
