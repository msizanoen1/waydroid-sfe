#!/usr/bin/env bash
set -ex
if command -v podman >/dev/null 2>&1; then
	runtime=podman
	runtime_flags_build=(--layers)
else
	runtime=docker
	runtime_flags_build=()
fi
"$runtime" build "${runtime_flags_build[@]}" -t waydroid-builder .
rm -rf waydroid/dist dist
"$runtime" run -v ./waydroid:/waydroid:z -w /waydroid waydroid-builder pyinstaller -s -y --add-data data:data ./waydroid.py "$@"
if [ -d waydroid/dist/waydroid ]
then
	cp -rT waydroid/dist/waydroid dist
else
	mkdir dist
	cp -T waydroid/dist/waydroid dist/waydroid
fi
