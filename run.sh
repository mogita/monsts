#!/bin/bash

set -e

if ! command -v docker &> /dev/null; then
    echo "Docker command not found. Please install Docker."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
  echo "will alias docker-compose to 'docker compose' command"
  docker-compose() {
    docker compose "$@"
  }
fi

echo "---> mastodon version: $CI_MASTODON_VERSION"

echo "---> working from directory: $CI_PATH"
cd $CI_PATH

echo "---> fixing elastic search directory permission..."
# es image uses 1000:1000 as the uid and gid
mkdir -p elasticsearch
chown -R 1000:1000 elasticsearch

echo "---> db migration..."
docker-compose run --build --rm web bundle exec rake db:migrate

echo "---> bringing up containers..."
docker-compose up -d --build --remove-orphans --force-recreate

echo done
