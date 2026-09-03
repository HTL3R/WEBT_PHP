FROM php:8.4-apache

# git/unzip, damit Composer Pakete beziehen und entpacken kann.
RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip \
    && rm -rf /var/lib/apt/lists/*

# Composer aus dem offiziellen Image übernehmen (Version reproduzierbar gepinnt).
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER=1

# DocumentRoot auf public/ umbiegen: nur dieser Ordner wird über HTTP
# ausgeliefert. composer.json, vendor/ und die Klassen liegen eine Ebene
# darüber und sind damit nicht per URL erreichbar.
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Serve index.php first; index.html stays reachable at /index.html.
RUN printf 'DirectoryIndex index.php index.html\n' > /etc/apache2/conf-available/directory-index.conf \
    && a2enconf directory-index

# Only src/ is copied, so the build scripts and the Dockerfile can never be
# served over HTTP. docker-compose.yml mounts src/ over this at runtime; the
# baked-in copy is what makes an exported image runnable on its own.
COPY src/ /var/www/html
WORKDIR /var/www/html

# Falls das Projekt eine composer.json hat: Abhängigkeiten installieren und
# den Autoloader bauen. Ohne composer.json passiert nichts (kein Fehler).
RUN if [ -f composer.json ]; then \
        composer install --no-interaction --no-dev --optimize-autoloader --no-progress; \
    fi

RUN chown -R www-data:www-data /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint

EXPOSE 80
ENTRYPOINT ["entrypoint"]
