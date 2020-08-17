#!/usr/bin/env bash
RAILS_MASTER_KEY=$(cat <(echo $RAILS_MASTER_KEY))
exec bundle exec rails "$@"


