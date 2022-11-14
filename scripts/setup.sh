#!/bin/sh
set -e

if [ ! -f .env.production ]; then
  echo "Creating initial .env.production file..."
  cp .env.production.sample .env.production
  sed -i s/SECRET_KEY_BASE=/SECRET_KEY_BASE=$(docker-compose run --rm web bundle exec rake secret)/ .env.production
  sed -i s/OTP_SECRET=/OTP_SECRET=$(docker-compose run --rm web bundle exec rake secret)/ .env.production
  vapid=$(docker-compose run --rm web bundle exec rake mastodon:webpush:generate_vapid_key)
  sed -i s/VAPID_PRIVATE_KEY=/$(echo $vapid | cut -d ' ' -f 1)/ .env.production
  sed -i s/VAPID_PUBLIC_KEY=/$(echo $vapid | cut -d ' ' -f 2)/ .env.production
fi

if [ ! -f conf/certs/selfsigned-priv.pem ]; then
  echo "Generating self-signed SSL certificate..."
  yes '' | openssl req -x509 -nodes -days 9999 -newkey rsa:2048 -keyout conf/certs/selfsigned-priv.pem -out conf/certs/selfsigned-cert.pem &>/dev/null
fi

if [ ! -d data/db ]; then
  docker-compose run --rm web bundle exec rails db:setup
fi

docker-compose run --rm web bundle exec rails db:migrate assets:precompile
