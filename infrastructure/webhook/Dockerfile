FROM ruby:alpine

WORKDIR /usr/src/webhook
COPY . .

RUN apk add git
RUN bundle install
CMD ["bundle", "exec", "ruby", "webhook.rb"]
