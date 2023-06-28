FROM ruby:2.7.3-alpine 

RUN apk add --update build-base \
    shared-mime-info \
    tzdata \
    postgresql-dev \
    postgresql-client

RUN gem install rails -v '5.0.2'

WORKDIR /var/www/
ADD Gemfile Gemfile.lock /var/www/
RUN bundle install