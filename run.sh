#!/bin/bash

set -e

echo "---> db migration..."
docker-compose run --rm web bundle exec rake db:migrate

echo "---> assets precompilation..."
docker-compose run --rm web bundle exec rake assets:precompile

echo "---> bringing up containers..."
docker-compose up -d --build

echo done
