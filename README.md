# Vanilla PHP

A starting point for students who want to build **without a framework**, in plain PHP.

Single entry point:

- **`src/index.php`** — rendered on the server. No JavaScript involved.

## Requirements

- [Docker](https://docs.docker.com/get-docker/) must be installed.

## Project structure

```
├── src/                 # your code — everything in here is served (Port 80)
│   └── index.php        # the start page
├── Dockerfile           # PHP 8.4 + Apache image
├── docker-compose.yml   # Docker Compose configuration
├── docker-entrypoint.sh # matches the web server user, then starts Apache
├── start.sh             # start/stop containers
└── build.sh             # build and export images
```

`src/` is both *mapped* into the container and *served*: here they are the same
folder, so everything you put in `src/` is reachable over HTTP. The Dockerfile and
the scripts sit outside it and can never be fetched.

## Start the environment

```bash
./start.sh
```

- **http://localhost** → the PHP page

### Where to work

**You work directly in `src/` on your own machine.** That folder is mapped into
the container:

```
src/  ->  /var/www/html   (inside the container)
```

So there is no separate place to put your code and nothing to copy anywhere: the
files you see in `src/` are exactly the files the web server runs. New files and
folders work too — `src/kontakt.php` is served at http://localhost/kontakt.php.

The mapping goes both ways, so anything your PHP code writes (uploads, generated
files) appears in `src/` as well, owned by you and editable as normal.

### Live editing

Because the folder is mapped rather than copied, **edit a file, reload the
browser, done** — no rebuild and no restart.

You only need `./build.sh` or `./start.sh -b` when the `Dockerfile` itself changes.

Run in the background:

```bash
./start.sh -d
```

## Stop the environment

```bash
./start.sh -s
```

## Further commands

| Command | Description |
|---------|-------------|
| `./start.sh -b` | Rebuild the image and start |
| `./start.sh -r` | Restart the container |
| `./start.sh -l` | Show logs |
| `./start.sh --status` | Show container status |

## Build and export images

Build the image (without starting it):

```bash
./build.sh
```

Clean build (without the Docker cache):

```bash
./build.sh -c
```

Build and export as a `.tar` file (to `_images/`):

```bash
./build.sh -e
```

Options can be combined:

```bash
./build.sh -c -e        # clean build and export
```

Load an exported image on another machine:

```bash
docker load -i _images/webt-php.tar
```

## Ports

| Service | URL |
|---------|-----|
| PHP app | http://localhost:80 |

The port can be changed with the `HTTP_PORT` environment variable:

```bash
HTTP_PORT=8080 ./start.sh
```

## File permissions

Apache runs as your own user so that files PHP creates (uploads, generated files)
stay editable on the host. The default is `1000:1000`, which is correct for Linux
and WSL. If `id -u` reports something else, set it explicitly:

```bash
PUID=$(id -u) PGID=$(id -g) ./start.sh
```
