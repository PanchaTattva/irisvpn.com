# syntax = docker/dockerfile:1.0-experimental
FROM ruby:alpine

ENV RAILS_ENV=production

WORKDIR /usr/src/irisvpn.com

RUN apk add sqlite-dev build-base tzdata openssl \
      nodejs npm yarn sqlite 
COPY . . 
RUN bundle install
RUN --mount=type=secret,id=rails,dst=/usr/src/irisvpn.com/config/master.key \
      rails db:migrate && \
      rails assets:precompile

CMD ["rails", "server", "-e", "production"]
