# MONSTS

A Mastodon setup with Docker and `docker compose`. MONSTS stands for Mastodon Of Not So Typical Setup.

# Prerequisites

- Docker and `docker-compose`
- [Nginx Proxy](https://github.com/nginx-proxy/nginx-proxy) and [ACME Companion](https://github.com/nginx-proxy/acme-companion)

# Usage

- Compose your own `.env.production` file in project root
- Run `docker compose up -d` from the project root directory to start

# References

Please refer to my [blog article](https://mogita.com/a-personal-mastodon-instance-setup) for description about this setup.

Links that helped me with this setup:

- Official Documentation https://docs.joinmastodon.org/admin/config/
- Wasabi Setup https://stanislas.blog/2018/05/moving-mastodon-media-files-to-wasabi-object-storage/
- Mastodon Docker Guide https://github.com/felx/mastodon-documentation/blob/master/Running-Mastodon/Docker-Guide.md

# License

This project is licensed under the terms of the [MIT license](LICENSE).
