# MONSTS

Create, customize and scale your Mastodon server with ease. Monsts stands for Mastodon Of Not So Typical Setup. Read my [blog article](https://mogita.com/a-personal-mastodon-instance-setup) for why and how I made this project.

# Features

- **Zero Setup:** No complicated server setup, just install Docker and you're ready to go
- **Container Orchestration:** Highly customizable and scalable with Docker Compose
- **Easy DevOps:** Automatic and secure workflow based on GitLab CI/CD
- **Multi-environment Deployment:** Easily run more than 1 Mastodon instance if you need to
- **Better Search:** Built-in ES patch for improved non-English search

# Prerequisites

- Docker and [Docker Compose](https://docs.docker.com/compose/install/)
- [Nginx Proxy](https://github.com/nginx-proxy/nginx-proxy) and [ACME Companion](https://github.com/nginx-proxy/acme-companion)
- Your domain name for the Mastodon site

# Guides

## Preparations

1. A Linux server with SSH key login enabled (other OS should work but not tested)
1. Create a key-pair on your server, put the public key into the `~/.ssh/authorized_keys`, and save the private key for later use (your can delete the key-pair from your server when completing this guide)
1. Install Docker and [Docker Compose](https://docs.docker.com/compose/install/)
1. Enable running the `docker` command as a non-root user ([official guide](https://docs.docker.com/engine/install/linux-postinstall/))
1. Start [Nginx Proxy](https://github.com/nginx-proxy/nginx-proxy) and [ACME Companion](https://github.com/nginx-proxy/acme-companion) for automatic Let's Encrypt SSL and nginx gateway
1. If you want to enable Email sending from your Mastodon server, make sure you obtain the SMTP hostname, port number, your username and password
1. If you want to enable S3 object storage, which is recommended since dumping all user images and videos on your VPS is never a good idea, you'll need to create a bucket and the Access Keys
1. Run the command `docker run --rm tootsuite/mastodon bundle exec rake secret` to generate strong secret codes for later use
1. Run the command `docker run --rm tootsuite/mastodon bundle exec rake mastodon:webpush:generate_vapid_key` to generate web push keys for later use

## Run Mastodon With GitLab CI/CD

> The recommended way. You can deploy and upgrade a Mastodon instance by just running a Pipeline.

Before start, please fork this repository, you can either set your repository public or private. The following steps all take place in your forked repository.

### Single Mastodon Instance

For most people this would be the case.

1. Visit the `Settings - CI/CD` of your forked repository
2. Expand the `Variables` section
3. Add all of the following Variables with proper values:
   - **For server access from CI/CD pipelines:**
   - `CI_REMOTE_HOST`: The IP address of your server
   - `CI_REMOTE_PATH`: The path to store Monsts deployment files and data (Docker will mount database directory in it too)
   - `CI_REMOTE_USERNAME`: The username of your server
   - `CI_PRIVATE_KEY`: The content of the private key generated from the Preparations
   - **For Nginx settings:**
   - `CI_SERVER_NAME`: The domain name of your Mastodon server, for example `mog.blue` (without `https://`)
   - `CI_LETSENCRYPT_EMAI`: The Email for Let's Encrypt SSL creation
   - **For Mastodon settings:**
   - `CI_MASTODON_SECRETS`: Copy / paste the content from previously generated secrets, example:
     ```
     SECRET_KEY_BASE=<some-key>
     OTP_SECRET=<some-key>
     ```
   - `CI_MASTODON_WEB_PUSH_KEYS`: Copy / paste the content from previously generated web push keys, example:
     ```
     VAPID_PRIVATE_KEY=<some-key>
     VAPID_PUBLIC_KEY=<some-key>
     ```
   - `CI_MASTODON_MAIL`: Copy and paste the following content, then change the values to fit your Email provider:
     ```
     SMTP_SERVER=smtp.example.com
     SMTP_PORT=587
     SMTP_LOGIN=your@email.address
     SMTP_PASSWORD=your-password
     SMTP_FROM_ADDRESS=your@email.address
     ```
   - `CI_MASTODON_FILE_STORAGE`: Copy and paste the following content, then change the values to fit your storage provider:
     ```
     S3_ENABLED=true
     S3_BUCKET=your-bucket-name
     S3_PROTOCOL=https
     S3_ALIAS_HOST=your-alias-host
     S3_REGION=your-region
     S3_ENDPOINT=https://your-endpoint.example.com
     AWS_ACCESS_KEY_ID=your-key
     AWS_SECRET_ACCESS_KEY=your-secret
     ```
   - `CI_POSTGRES_PASSWORD`: The password for database. It's recommended to generate a complex string using a password generator like [this one](https://passwordsgenerator.net). Just DON'T leave this empty or your database lacks password protection.
   - `CI_ELASTIC_PASSWORD`: The password to secure the ElasticSearch instance, can leave empty if you won't enable ElasticSearch. By default ES is disabled, you can enable it by changing the `ES_ENABLED` config from `.env.production`.
   - `CI_SSL_CA`: The SSL CA to secure ElasticSearch instance, can leave empty as ditto
   - `CI_SSL_CERT`: The SSL certificate to secure ElasticSearch, can leave empty as ditto
   - `CI_SSL_KEY`: The SSL private key to secure ElasticSearch, can leave empty as ditto

# References

Links that helped me with this setup:

- Official Documentation https://docs.joinmastodon.org/admin/config/
- Wasabi Setup https://stanislas.blog/2018/05/moving-mastodon-media-files-to-wasabi-object-storage/
- Mastodon Docker Guide https://github.com/felx/mastodon-documentation/blob/master/Running-Mastodon/Docker-Guide.md
- SSL Certificate Guide For ES https://www.modb.pro/db/99726

# License

This project is licensed under the terms of the [MIT license](LICENSE).
