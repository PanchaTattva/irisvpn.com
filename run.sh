#!/bin/bash

bundle install
yarn install --check-files;
RAILS_ENV=production rails db:migrate
RAILS_ENV=production rails assets:precompile
rails server -e production
