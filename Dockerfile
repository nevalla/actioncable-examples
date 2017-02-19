FROM ruby:2.3-slim
MAINTAINER Lauri Nevala <lauri@kontena.io>
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential sqlite3 libsqlite3-dev nodejs libpq-dev
RUN gem install bundler
ENV INSTALL_PATH /app
ENV RAILS_ENV=production
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN bundle exec rake ACTION_CABLE_ALLOWED_REQUEST_ORIGINS=foo,bar SECRET_TOKEN=dummytoken assets:precompile
VOLUME ["$INSTALL_PATH/public"]
EXPOSE 3000
CMD puma -C config/puma.rb
