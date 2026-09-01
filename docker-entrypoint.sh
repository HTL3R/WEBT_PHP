#!/usr/bin/env bash
set -e

chown -R www-data:www-data /var/www/data

exec apache2-foreground
