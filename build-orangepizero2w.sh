#!/usr/bin/env bash
set -e

if [[ -f "./src/config" ]]; then
	rm "./src/config"
fi
cat "./config/default" >> ./src/config
cat "./config/armbian/default" >> ./src/config
cat "./config/armbian/orangepizero2w" >> ./src/config
source ./src/config

IMGCOUNT=$(ls ./src/image/*orangepi*zero2w*.img.xz 2>/dev/null | wc -l)
if [ $IMGCOUNT -eq 0 ]; then
	echo "Downloading Orange Pi Zero 2W base image..."
	find ./src/image -type f -not -name '.gitkeep' -delete
	aria2c -d ./src/image --seed-time=0 $DOWNLOAD_URL_IMAGE
fi
pushd ./src
sudo bash -x ./build_dist
popd
rm "./src/config"
