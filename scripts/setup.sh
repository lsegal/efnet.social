#!/bin/sh

openssl req -x509 -nodes -days 9999 -newkey rsa:2048 -keyout conf/certs/selfsigned-priv.pem -out conf/certs/selfsigned-cert.pem
docker-compose run --rm web bundle exec rails db:setup 2>/dev/null
docker-compose run --rm web bundle exec rails db:migrate assets:precompile
