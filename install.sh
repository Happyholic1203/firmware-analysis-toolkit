#!/bin/bash

git submodule update --init --recursive

sudo apt-get update

sudo apt-get install -yq binwalk

apt-get install -yq python-lzma busybox-static fakeroot git kpartx netcat-openbsd nmap python-psycopg2 python3-psycopg2 snmp uml-utilities util-linux vlan qemu-system-arm qemu-system-mips qemu-system-x86 qemu-utils postgresql python-pip git build-essential zlib1g-dev liblzma-dev python-magic mitmproxy

pushd firmadyne
./download.sh
sed -i "s%^#FIRMWARE_DIR=.*$%FIRMWARE_DIR=$(pwd)%" firmadyne.config
sudo -u postgres createuser -P firmadyne  # interactively input password (firmadyne)
pushd /tmp
sudo -u postgres createdb -O firmadyne firmware
popd
sudo -u postgres psql -d firmware < ./firmadyne/database/schema
popd

# Setup FAT

pip install pexpect
chmod +x fat.py reset.py

sed -i "s%^firmadyne_path\s*=.*$%firmadyne_path = \"$(cd firmadyne; pwd)\"%" fat.py
sed -i "s%^binwalk_path\s*=.*$%binwalk_path = \"$(which binwalk)\"%" fat.py

# Setup Firmware-mod-Kit

pushd firmware-mod-kit
sed -i "s%^BINWALK=.*$%BINWALK=$(which binwalk)%" shared-ng.inc
popd

