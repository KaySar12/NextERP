#!/usr/bin/bash
set +x
sed -i "s/TAG := \$(shell rev-parse --abbrev-ref HEAD)/TAG := $1/g" Makefile
