# Vanilla PHP

A starting point for students who want to build **without a framework**, in plain PHP.

Single entry point: 

- **`index.php`** — rendered on the server. No JavaScript involved.

## Run it

```bash
./start.sh
```

- **http://localhost** → the PHP page

Stop with `./start.sh -s`. Run `./start.sh -h` for all options
(`-b` rebuild, `-d` background, `-r` restart, `-l` logs, `--status`).

Override the port with `HTTP_PORT=8080 ./start.sh`.

## Build the image

```bash
./build.sh            # build the image
./build.sh -c         # clean build (no cache)
./build.sh -e         # build and export to _images/webt-php.tar
```
