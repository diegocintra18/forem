#!/bin/bash

notify () {
  FAILED_COMMAND="$(caller): ${BASH_COMMAND}" \
    bundle exec rails runner "ReleasePhaseNotifier.ping_slack"
}

trap notify ERR

# enable echo mode (-x) and exit on error (-e)
# -E ensures that ERR traps get inherited by functions, command substitutions, and subshell environments.
set -Eex

# runs migration for Postgres and boots the app to check there are no errors
STATEMENT_TIMEOUT=4500000 bundle exec rails app_initializer:setup
bundle exec rake fastly:update_configs
bundle exec rails runner "puts 'app load success'"
