SHELL=/usr/bin/env bash -o pipefail
VERSION ?= "v$$(cat buildpack.toml | grep version | sed -e 's/version = //g' | xargs)"
BUILDPACK_TOML_VERSION := v$(shell sed -n 's/^version = \"\(.*\)\"/\1/p' buildpack.toml)
GIT_TAG=$(shell git describe --tags `git rev-list --tags --max-count=1`)

.PHONY: release
release: 
	tar -C . -cvzf buildpack-apt-$(VERSION).tgz ./bin ./buildpack.toml ./README.md

.PHONY: version-check
version-check:
ifneq ($(GIT_TAG),$(BUILDPACK_TOML_VERSION)) 
	echo git tag: $(GIT_TAG)
	echo version: $(BUILDPACK_TOML_VERSION)
	exit 1
endif
