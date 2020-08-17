FROM ruby:alpine

ARG RAILS_MASTER_KEY

ENV RAILS_ENV=production

WORKDIR /usr/src/irisvpn.com

RUN apk add sqlite-dev build-base tzdata openssl \
      nodejs npm yarn sqlite 
COPY . . 
RUN bundle install
RUN rails db:migrate
RUN rails assets:precompile

CMD ["rails", "server", "-e", "production"]
