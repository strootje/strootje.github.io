#!/usr/bin/env bash

hugo -t osprey
(cd ./public \
	&& git add --all \
	&& git commit -m "$1" \
	&& git push origin master)
