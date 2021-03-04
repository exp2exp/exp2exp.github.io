# notes

## introduction

This is a repository of notes stored in [org](https://orgmode.org/manual/) format in the `src` directory. These notes are generated with [firn](https://github.com/theiceshelf/firn) and served via [github pages](https://docs.github.com/en/free-pro-team@latest/github/working-with-github-pages) on the `gh-pages` branches built automatically with the github action in `.github/workflows/src-build.yml`.

## usage

To access the local slip-box, you need to define the location of your local
repository in `.dir-locals.el` (at the root).  A template and instructions are
available in [`.dir-locals.default.el`](.dir-locals.default.el).

You can edit the `org` files in the `src` directory. These can be used with [org-roam](https://www.orgroam.com/), but this is not required.

The `Makefile` contains targets for working with git and [firn](https://github.com/theiceshelf/firn). First, make sure firn is available in your `$PATH` or issue the `make firn` command to install (mac and linux only).

Assuming you have firn installed, you can view the existing compiled version using
``` sh
make srv
```
and navigating to http://localhost:4000 by default. You can regenerate the static site in `src/_firn` by running
``` sh
make build
```

To commit changes to the current branch run
``` sh
make commit
```
To deploy directly run
``` sh
make deploy
```
