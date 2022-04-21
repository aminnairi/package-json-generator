# Contributing

## Requirements

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [GNU/Make](https://www.gnu.org/software/make/)

## Installation

```bash
git clone https://github.com/aminnairi/elm-template my-elm-project
cd my-elm-project
```

## Setup

```bash
cp .env.example .env
```

## Permissions

*Permissions used to create/read/update/delete files from the container to your local filesystem.*

```bash
vim .env
```

```env
USER_IDENTIFIER="1000"
```

Update the `1000` value according to your operating system. Use the `id` command to get your own user identifier.

```bash
id -u
```

## Repl

*For quickly testing Elm expressions.*

```bash
make repl
```

## Development

*For serving the project at [`localhost:8000`](http://localhost:8000/).*

```bash
make development
```

## Production

*For building the files for production in the `build` folder.*

```bash
make production
```

## Clean

*For removing all files listed in the `.gitignore`. Warning: this will also remove the `.env` file!*

```bash
make clean
```
