# apt Buildpack

[![Version](https://img.shields.io/badge/dynamic/json?url=https://cnb-registry-api.herokuapp.com/api/v1/buildpacks/fagiani/apt&label=Version&query=$.latest.version)](https://github.com/fagiani/apt-buildpack)

This is a [Cloud Native Buildpack](https://buildpacks.io/) that adds support for `apt`-based dependencies during both build and runtime.

This buildpack is based on the [heroku-buildpack-apt](https://github.com/heroku/heroku-buildpack-apt)


## Usage

This buildpack is not meant to be used on its own, and instead should be in used in combination with other buildpacks.

Include a list of `apt` package names to be installed in a file named `Aptfile`; be aware that line ending should be LF, not CRLF.

The buildpack automatically downloads and installs the packages when you run a build:

```
$ pack build --buildpack fagiani/apt myapp
```

#### Aptfile

    # you can list packages
    libexample-dev

    # or include links to specific .deb files
    http://downloads.sourceforge.net/project/wkhtmltopdf/0.12.1/wkhtmltox-0.12.1_linux-precise-amd64.deb

    # or add custom apt repos (only required if using packages outside of the standard Ubuntu APT repositories)
    :repo:deb http://cz.archive.ubuntu.com/ubuntu artful main universe

    # for repos without a GPG key in the builder, use [trusted=yes] to skip signature verification
    :repo:deb [trusted=yes] http://ppa.launchpad.net/deadsnakes/ppa/ubuntu jammy main

## Custom Repository Order

By default, custom repositories defined with `:repo:` in your `Aptfile` are **appended** after the system's default repositories. You can control this behavior using the `APT_CUSTOM_REPOS_MODE` environment variable:

| Value | Behavior |
|-------|----------|
| `append` (default) | System repos first, then custom repos |
| `prepend` | Custom repos first, then system repos |
| `custom-only` | Only custom repos are used (system repos are excluded entirely) |

Example:

```
$ pack build --buildpack fagiani/apt --env APT_CUSTOM_REPOS_MODE=prepend myapp
```

> **Note:** On Ubuntu 24.04-based builders (e.g., `heroku/builder:24`), system repositories use the deb822 format in `/etc/apt/sources.list.d/`. In `append` and `prepend` modes, custom repos are placed in `sources.list` alongside the system's `sources.list.d/` entries. In `custom-only` mode, both `sources.list` and `sources.list.d/` are replaced with only your custom repositories.

## License

MIT

## Disclaimer

This buildpack is experimental and not yet intended for production use.
