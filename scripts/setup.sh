#!/bin/sh

docker-compose run --rm web bundle exec rails db:setup db:migrate assets:precompile
