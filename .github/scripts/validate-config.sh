#!/usr/bin/env bash
#
# Checks git for new fetch_env! calls and ensures those environment variables
# are defined in Helm configuration. Missing variables will cause deployment
# to fail.
#

set -eou pipefail

# Run from the root of the repository
cd "$(dirname "$0")/../.."

diff=$(git diff --name-only HEAD^)
errors=0

for file in $diff; do
  if [[ ! "$file" == config/* ]]; then
    continue
  fi

  echo "==> $file"

  new_lines=$(git diff HEAD^ "$file" | grep ^+ | grep 'fetch_env!' || echo)
  echo "$new_lines"

  IFS=$'\n'
  for line in $new_lines; do
    # Extract var from System.fetch_env!("VAR") pattern
    var=$(echo "$line" | grep -oE 'fetch_env!\("[A-Z0-9_]+"\)' | grep -oE '"[A-Z0-9_]+"' | tr -d '"' || echo)

    # Extract var from "VAR" |> System.fetch_env!() pattern
    if [ -z "$var" ]; then
      var=$(echo "$line" | grep -oE '"[A-Z0-9_]+" \|> (System\.)?fetch_env!\(\)' | grep -oE '"[A-Z0-9_]+"' | tr -d '"' || echo)
    fi

    if [ -z "$var" ]; then
      continue
    fi

    echo "====> ${var}"

    if grep -rqE "^[[:space:]]*${var}[[:space:]]*:" helm/; then
      echo "OK"
    else
      echo "ERROR: Environment variable '${var}' referenced in ${file} is not configured in helm/ directory" >&2
      errors=$((errors + 1))
    fi
  done
done

exit $errors
