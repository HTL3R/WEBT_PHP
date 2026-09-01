# Vanilla PHP

A starting point for students who want to build **without a framework**, in plain PHP.

Single entry point:

- **`index.php`** — rendered on the server. No JavaScript involved.

## Requirements

- [Docker](https://docs.docker.com/get-docker/) must be installed.

## Project structure

```
├── index.php            # the app — rendered on the server (Port 80)
├── Dockerfile           # PHP 8.4 + Apache image
├── docker-compose.yml   # Docker Compose configuration
├── docker-entrypoint.sh # fixes permissions, then starts Apache
├── start.sh             # start/stop containers
└── build.sh             # build and export images
```

## Start the environment

```bash
./start.sh
```

- **http://localhost** → the PHP page

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
