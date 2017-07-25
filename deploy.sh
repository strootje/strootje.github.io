#!/usr/bin/env bash
(cd ./public && git add --all && git commit -m "$1" && git push origin master)
