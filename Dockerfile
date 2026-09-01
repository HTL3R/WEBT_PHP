# PHP pinned to the WSC2026 spec. Apache serves index.php, index.html, JS and CSS
# from one document root — no extra web server config needed.
FROM php:8.4-apache

#RUN apt-get update && apt-get install -y --no-install-recommends libsqlite3-dev \
#    && docker-php-ext-install -j"$(nproc)" pdo_sqlite \
#    && rm -rf /var/lib/apt/lists/*

# Serve index.php first; index.html stays reachable at /index.html.
RUN printf 'DirectoryIndex index.php index.html\n' > /etc/apache2/conf-available/directory-index.conf \
    && a2enconf directory-index

COPY . /var/www/html
# .dockerignore keeps the build/compose files out of the context; the entrypoint has to
# stay in it for the COPY below, so it is the only one left to strip from the doc root.
RUN rm -f /var/www/html/docker-entrypoint.sh

# The SQLite file lives outside the document root so it cannot be fetched over HTTP.
RUN chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 80
ENTRYPOINT ["entrypoint"]
