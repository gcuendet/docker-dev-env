# docker-dev-env
Docker image with my development environment set up.

## Getting started

Build the docker image

```bash
docker build --build-arg USER=$(whoami) --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t focal-dev-env .
```