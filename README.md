CI-utils
========

This repository contains a collection of scripts for Continuous Integration (CI)
that we use across Openmeeg repositories.
Its main purpose is to provide all our projects with a common manner to install
their dependencies, but using a script archive rather than copy pasting bits and
pieces in CI's config files provide also two main advantages:

- a natural manner for more comprehensive scripting.
- documenting the installation process.

Usage
-----
In order to avoid code injection [through detecting the pipelining on the server side](https://www.idontplaydarts.com/2016/04/detecting-curl-pipe-bash-server-side/), we recommend to call the scripts as follow:
```sh
- sh -c "$(curl -fsSkL ${SCRIPT_URL_PATH})"
```

Todo
----

-[ ] Add tests to the scripts
-[ ] Add usage examples
