# EFnet.social Mastodon Deploy Configuration

This repository contains configuration (minus secrets) for
the [efnet.social](https://efnet.social) Mastodon instance.

You can fork this repository and use it as a template for your own.

## Prerequisites

- Docker with `docker-compose` (latest)
- Some kind of sh-compatible shell.

## Setup & Deploy

1. Clone this repository: `git clone https://github.com/lsegal/efnet.social`
2. Run `sh scripts/setup.sh` to initialize `.env.production` from the
   `.env.production.sample` template file with configuration. This will also
   set up your database and initial certificates.
3. Continue editing `.env.production` and add your remaining secrets & settings.
   See the [Mastodon documentation](https://docs.joinmastodon.org/admin/config/)
   for available environment options.
4. Optional: if you are using your own certificates, you will need to replace
   the files generated into `conf/certs`. See below for more information.
5. Finally, run `docker-compose up -d` to start the server.
6. If you configured everything correctly (and your domain is pointed at your
   server), you should now be able to see your Mastodon instance running at the
   `LOCAL_DOMAIN` you configured in `.env.production`.

## Optional Steps

### Create your administator account

You can sign up your first account via the web interface, but you may prefer
to directly configure your user via `tootctl` (see below) in order to bypass
email confirmation if you have not configured SMTP.

Use the following command to create your first user and make yourself an admin:

```sh
sh scripts/tootctl.sh accounts create USERNAME --email EMAIL --role Admin --confirmed
```

### Lock down your instance

You can disable signups via `tootctl` as well with the following command:

```sh
sh scripts/tootctl.sh settings registrations close
```

## SSL and Certificates

This deploy relies on Cloudflare for SSL management. Specifically, we use
the "Full" end-to-end setting in SSL/TLS > Overview. This means that you should
ensure that Cloudflare is accessing your server on port 443. Failure to setup
your service over HTTPS may result in a redirect loop.

![Cloudflare SSL settings](docs/cf-config.png)

If you are not using Cloudflare, you will need to generate your own certificates.
This can be done by replacing the certificates in `conf/certs` and updating
`config/nginx-templates/default.conf.template`.

## Tools and Maintenance

The `scripts` directory contains a few useful tools for managing your instance,
most of which are wrappers around `docker-compose` commands available in
the standard Mastadon tool chain.

- `scripts/console.sh` provides access to the Rails console in your Mastodon instance.
- `scripts/tootctl.sh` provides access to [Mastoson's tootctl admin CLI](https://docs.joinmastodon.org/admin/tootctl/).
