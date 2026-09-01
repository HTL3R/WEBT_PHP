#!/usr/bin/env bash
set -e

chown -R www-data:www-data /var/www/html

exec apache2-foreground
