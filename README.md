cdnjs.el
========

A front end for http://cdnjs.com

## Synops

This is an Emacs package for searching, getting information and
downloading Javascript or CSS packages from [cdnjs].

The Emacs package uses [gocdnjs] to get information about [cdnjs] packages.

## Features

- List [cdnjs] packages like `package.el`
- Download Javascript or CSS packages fom [cdnjs].
- Insert [cdnjs] URL.

### List packages and download a package
![](https://raw.github.com/yasuyk/misc/master/cdnjs.el/demo-cdnjs-list-and-download.gif)

### Insert URL
![](https://raw.github.com/yasuyk/misc/master/cdnjs.el/demo-cdnjs-insert-url.gif)


## Requirement

- [gocdnjs] used as external program.

## Installation

### cdnjs.el

If you're an Emacs 24 user or you have a recent version of `package.el`
you can install `cdnjs.el` from the [MELPA](http://melpa.milkbox.net/) repository.

### [gocdnjs]

#### M-x cdnjs-install-gocdnjs

The easiest way to install to install `gocdnjs` is to execute `M-x cdnjs-install-gocdnjs`.

Note that Executing `cdnjs-install-gocdnjs` require `wget` and `unzip` commands.

After installed, You need not to configure `cdnjs-gocdnjs-program`.

#### go get

If you are familiar with Go Programming language, you can install `gocdnjs` by `go get` command.

`go get github.com/yasuyk/gocdnjs`

After installed, configure `cdnjs-gocdnjs-program` as follow:

    (setq cdnjs-gocdnjs-program "/somewhere/bin/gocdnjs")

#### Standalone

`gocdnjs` can be easily installed as an executable. Download the latest [compiled
binary forms of gocdnjs](https://github.com/yasuyk/gocdnjs/releases) for Darwin, Linux and Windows.

After installed, configure `cdnjs-gocdnjs-program` as follow:

    (setq cdnjs-gocdnjs-program "/somewhere/bin/gocdnjs")

## Usage

- Install `gocdnjs` command:

    `M-x cdnjs-install-gocdnjs`

    `wget` and `unzip` commands are required to use this function.

- List packages that are retrieved from [cdnjs]:

    `M-x cdnjs-list-packages`

- Describe the package information:

    `M-x cdnjs-describe-package`

- Insert URL of a JavaScript or CSS package:

    `M-x cdnjs-insert-url`

- Select version and file of a JavaScript or CSS package, then insert URL.:

    `M-x cdnjs-select-and-insert-url`

- Update the package cache file:

    `M-x cdnjs-update-package-cache`

## Customization

- Function to be called when requesting input from the user:

    `cdnjs-completing-read-function` (default `ido-completing-read`)

- Name of `gocdnjs' command:

    `cdnjs-gocdnjs-program` (default `~/.gocdnjs/bin/gocdnjs`)

[cdnjs]:http://cdnjs.com
[gocdnjs]:https://github.com/yasuyk/gocdnjs
