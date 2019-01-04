FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs mysql-client
RUN mkdir /app
WORKDIR /app
ADD ./Gemfile /app/Gemfile
ADD ./Gemfile.lock /app/Gemfile.lock

RUN apt-get install -qq -y cron

RUN bundle install
ADD . /app

RUN bundle config --delete frozen \
 && apt-get update -qq && apt-get install -y build-essential \
 && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
 && apt-get install -y nodejs \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update && apt-get install yarn \
 && rm -rf /var/lib/apt/lists/*

# make directory for sockert
RUN mkdir -p tmp/sockets

VOLUME /app/public
VOLUME /app/tmp

# react build
ADD ./react/yarn.lock /usr/src/app/yarn.lock
ADD ./react/package.json /usr/src/app/package.json
WORKDIR /app/react
RUN yarn install && ./node_modules/.bin/parcel build ./src/App.js

# copy dist files to assets folder
WORKDIR /app
RUN cp ./react/dist/App.js ./app/assets/javascripts/react/App.js
RUN cp ./react/dist/App.map ./app/assets/javascripts/react/App.map

CMD bash -c "export RAILS_ENV=production && rm -f tmp/pids/server.pid && bundle install && bundle exec rails db:create && bundle exec rails db:migrate && rake assets:precompile && rails server --environment production"