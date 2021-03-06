FROM ruby:2.5.3-alpine AS build-env

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="postgresql-dev yaml-dev zlib-dev nodejs yarn"
ARG RUBY_PACKAGES="tzdata"

ENV RAILS_ENV=production
ENV NODE_ENV=production
ENV BUNDLER_VERSION=2.0.1
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

COPY Gemfile* package.json yarn.lock ./

# install rubygems
COPY Gemfile Gemfile.lock $RAILS_ROOT/
RUN gem install bundler --version $(cat Gemfile.lock | tail -1 | tr -d " ") \
    && bundle config --global frozen 1 \
    && bundle install --without development:test:assets -j4 --retry 3 --path=vendor/bundle \
    # Remove unneeded files (cached *.gem, *.o, *.c)
    && rm -rf vendor/bundle/ruby/2.5.0/cache/*.gem \
    && find vendor/bundle/ruby/2.5.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/2.5.0/gems/ -name "*.o" -delete

RUN yarn install --production
COPY . .
RUN bundle exec rake assets:precompile

# remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache app/assets vendor/assets spec

############### Build stage done ###############

FROM ruby:2.5.3-alpine

ARG RAILS_ROOT=/app
ARG PACKAGES="tzdata postgresql-client nodejs bash"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
    && apk upgrade \
    && apk add --update --no-cache $PACKAGES

COPY --from=build-env $RAILS_ROOT $RAILS_ROOT

# install bundler
RUN gem install bundler --version $(cat Gemfile.lock | tail -1 | tr -d " ")

CMD bundle exec puma -C config/puma.rb
