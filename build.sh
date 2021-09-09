#!/usr/bin/env bash
set -ex
podman build --layers -t waydroid-builder .
rm -rf waydroid/dist dist
podman run -v ./waydroid:/waydroid:z -w /waydroid waydroid-builder pyinstaller -s -y --add-data data:data ./waydroid.py "$@"
if [ -d waydroid/dist/waydroid ]
then
	cp -rT waydroid/dist/waydroid dist
else
	mkdir dist
	cp -T waydroid/dist/waydroid dist/waydroid
fi
