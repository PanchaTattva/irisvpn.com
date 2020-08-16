FROM ruby:alpine

ENV RAILS_ENV=production
WORKDIR /usr/share/rails_app

RUN apk add sqlite-dev build-base tzdata openssl \
      nodejs npm yarn sqlite 
COPY . . 
RUN bundle install
RUN rails db:migrate
RUN rails assets:precompile

CMD ["rails", "server", "-e", "production"]
