#!/usr/bin/env bash
(cd ./public && git add --all && git commit -m "Redeployment (`date`) - $1" && git push origin master)
