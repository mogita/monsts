#!/bin/bash

set -e

echo "---> db migration..."
docker-compose run --rm web rake db:migrate && sudo

echo "---> assets precompilation..."
docker-compose run --rm web rake assets:precompile

echo "---> bringing up containers..."
docker-compose up -d --build

echo done
