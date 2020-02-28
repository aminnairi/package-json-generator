# Contributing

## Requirements

- [Git](https://git-scm.com/)
- [Docker](https://www.docker.com/)
- [GNU/Make](https://www.gnu.org/software/make/)

## 1. Choose an issue to resolve

[Issues](https://github.com/aminnairi/package-json-generator/issues).

## 2. Fork the project

[Documentation](https://help.github.com/en/github/getting-started-with-github/fork-a-repo).

## 3. Clone the project

```console
$ git clone https://github.com/$USER/package-json-generator.git
$ cd package-json-generator
```

Where `$USER` is your GitHub's username.

## 4. Install the Node.js dependencies

```console
$ make install
```

## 5. Resolve the issue

```console
$ make build
$ make start
```

You can now open the page http://localhost/ in your favorite browser. Run the `make build` command if you want to update the Web application.

## 6. Create a new branch

```console
$ git branch feature-or-fix
$ git checkout feature-or-fix
```

Where `feature-or-fix` is the name of your branch.

## 7. Commit your changes

```console
$ git add .
$ git commit --message "added something to solve something"
```

Where `added something to solve something` is your commit message.

## 8. Publish your branch

```console
$ git push --set-upstream-to origin feature-or-fix
```

## 9. Submit your pull request

[Documentation](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request).
