#!/bin/bash

set -e

cd $CI_PATH

echo "---> fixing elastic search directory permission..."
mkdir -p elasticsearch
chown -R elasticsearch:elasticsearch elasticsearch

echo "---> db migration..."
docker-compose run --rm web bundle exec rake db:migrate

echo "---> assets precompilation..."
docker-compose run --rm web bundle exec rake assets:precompile

echo "---> bringing up containers..."
docker-compose up -d --build

echo done
