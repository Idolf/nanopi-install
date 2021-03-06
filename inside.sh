#!/bin/bash

set -eu

locale-gen
update-locale LC_ALL="en_US.UTF-8"
update-locale LANG="en_US.UTF-8"
update-locale LANGUAGE="en_US.UTF-8"

apt-get update
apt-get dist-upgrade -y

useradd idolf -m -G sudo -s /bin/bash
mv /home/idolf-ssh /home/idolf/.ssh
chown idolf: -R /home/idolf/.ssh
chmod og-rwx -R /home/idolf/.ssh

echo export PATH=/home/idolf/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin >> /home/idolf/.bashrc

dpkg -i linux-image-*.deb
dd if=/usr/lib/u-boot/nanopi_neo/u-boot-sunxi-with-spl.bin of=/dev/mmcblk0 bs=1024 seek=8
cp /usr/lib/linux-image-*-armmp/*.dtb /boot
mkimage -A arm -T ramdisk -C none -n uInitrd -d /boot/initrd.img-*-armmp /boot/uInitrd
mkimage -A arm -C none -T script -d /boot/boot.ini /boot/boot.scr
(cd /boot; ln -s vmlinuz-*-armmp zImage)

rm -f linux-image-*.deb || true
rm -r inside.sh
