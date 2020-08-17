FROM ruby:alpine

ENV RAILS_ENV=production
ENV RAILS_MASTER_KEY=$secret

WORKDIR /usr/share/rails_app

RUN apk add sqlite-dev build-base tzdata openssl \
      nodejs npm yarn sqlite 
COPY . . 
RUN bundle install
RUN echo $RAILS_MASTER_KEY | wc -c
RUN rails db:migrate ---trace
RUN rails assets:precompile

CMD ["rails", "server", "-e", "production"]
