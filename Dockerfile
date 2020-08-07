FROM ruby:alpine

ENV RAILS_ENV=production
WORKDIR /usr/share/rails_app

RUN apk add sqlite sqlite-dev build-base tzdata nodejs npm yarn
COPY /rails_app ./ 
RUN bundle install
RUN rails db:migrate
RUN rails assets:precompile

CMD ["rails", "server", "-e", "production"]
