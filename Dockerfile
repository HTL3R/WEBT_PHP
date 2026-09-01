FROM php:8.4-apache

# Serve index.php first; index.html stays reachable at /index.html.
RUN printf 'DirectoryIndex index.php index.html\n' > /etc/apache2/conf-available/directory-index.conf \
    && a2enconf directory-index

# Only src/ is copied, so the build scripts and the Dockerfile can never be
# served over HTTP. docker-compose.yml mounts src/ over this at runtime; the
# baked-in copy is what makes an exported image runnable on its own.
COPY src/ /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 80
ENTRYPOINT ["entrypoint"]
