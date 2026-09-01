FROM php:8.4-apache

# Serve index.php first; index.html stays reachable at /index.html.
RUN printf 'DirectoryIndex index.php index.html\n' > /etc/apache2/conf-available/directory-index.conf \
    && a2enconf directory-index

COPY . /var/www/html
# .dockerignore keeps the build/compose files out of the context; the entrypoint has to
# stay in it for the COPY below, so it is the only one left to strip from the doc root.
RUN rm -f /var/www/html/docker-entrypoint.sh

# Apache runs as www-data and has to be able to read everything it serves.
RUN chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 80
ENTRYPOINT ["entrypoint"]
