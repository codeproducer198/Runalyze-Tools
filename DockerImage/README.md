# Runalyze-Docker

Docker samples/templates for self-hosted RUNALYZE.

On the [RUNALYZE docs](https://github.com/Runalyze/docs) and [RUNALYZE admin-docs](https://github.com/Runalyze/admin-docs) you can find documents for installing RUNALYZE 4.

But it tooks a few day for me to get RUNALYZE self-hosted running with all parts (i mean bulk-imports, queue-processing/poster-generation, user registration and so on).

I hope the samples/extracts of my Dockerfiles and docker-compose helps you to speed up this initial phase ;-)

Some facts:
* I used a self build docker-image-base based on Debian Bullseye/ARM64 minbase-variant.
* I used [RUNIT](http://smarden.org/runit/) for the container init system (you can use any other system but must perhaps change the commands below)
* I running MariaDB/mysql in an own container. 
* PHP + RUNALYZE + nginx running in the app-container with this `Dockerfile`.
* Administration of the containers is done with docker-compose (see `docker-compose.yml`).
* The mail configuration files, the logfiles and the TLS certificates are used from the host.
* Also the folder for bulk-import of activities and the high-data (SRTM) is also on the host.
* PHP and nginx running with user `dockusr`.

Commands for the docker container:
* nginx: `exec /usr/sbin/nginx -g "daemon off;"`
* PHP: `exec /usr/sbin/php-fpm --nodaemonize`
* Queue: `exec chpst -u dockusr /usr/bin/php /app/runalyze/bin/console runalyze:queue:consume --env=prod --no-debug --stop-when-empty`

Other commands:
* bulk-import: `chpst -u dockusr /usr/bin/php /app/runalyze/bin/console runalyze:activity:bulk-import --env=prod <user> /app/runalyze_import [--sport=cycling|swimming|hiking|mountaineering] [--move=imported-folder]`
