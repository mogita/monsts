#!/bin/bash

set -e

echo "---> working from directory: $CI_PATH"
cd $CI_PATH

echo "---> fixing elastic search directory permission..."
# es image uses 1000:1000 as the uid and gid
mkdir -p elasticsearch
chown -R 1000:1000 elasticsearch

echo "---> db migration..."
docker-compose run --rm web bundle exec rake db:migrate

echo "---> assets precompilation..."
docker-compose run --rm web bundle exec rake assets:precompile

echo "---> bringing up containers..."
docker-compose up -d --build --remove-orphans --force-recreate

echo done
