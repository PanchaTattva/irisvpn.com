#!/bin/bash

rm -f tmp/pids/server.pid
bundle install
yarn install --check-files;
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails assets:precompile
rails server -e production
