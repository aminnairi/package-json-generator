# package-json-generator

Quickly generate your NPM configuration according to https://docs.npmjs.com/files/package.json.

## Usage

See [aminnairi.github.io/package-json-generator](https://aminnairi.github.io/package-json-generator/).

## Development

### Requirements

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

### Installation

```console
$ git clone https://github.com/aminnairi/package-json-generator.git
$ cd package-json-generator
$ docker-compose build
$ docker-compose run --rm npm install
```

### Commands

#### Serve

```console
$ docker-compose run --rm --service-ports elm reactor
```

#### Clean

```console
$ docker-compose run --rm sh rm -rf .elm elm-stuff
```
