#!/usr/bin/env bash

set -e

sudo mkdir -pv /mnt/data/root
sudo mkdir -pv /mnt/data/subvol
sudo mkdir -pv /mnt/data/snapshots

sudo sfdisk /dev/sdb < /media/sf_vagrant/disk-data.sfdisk
sudo mkfs.btrfs /dev/sdb1
sudo mount -v /dev/sdb1 /mnt/data/root
sudo btrfs subvolume create /mnt/data/root/subvol
sudo btrfs subvolume create /mnt/data/root/snapshots

sudo cat <<EOS | sudo tee -a /etc/fstab > /dev/null

# /dev/sdb1 - subvolume '/' (root)
/dev/sdb1 /mnt/data/root      btrfs ro,noatime                   0 0

# /dev/sdb1 - subvolume '/subvol'
/dev/sdb1 /mnt/data/subvol    btrfs rw,noatime,subvol=/subvol    0 0

# /dev/sdb1 - subvolume '/snapshots'
/dev/sdb1 /mnt/data/snapshots btrfs rw,noatime,subvol=/snapshots 0 0
EOS

sudo mount -av

dummy_file="/tmp/$USERNAME/backup_dummy"
head -c 512M </dev/urandom >"$dummy_file"
sudo cp -v "$dummy_file" "/mnt/data/root/subvol/file1"
sudo cp -v "$dummy_file" "/mnt/data/root/subvol/file2"
rm -v "$dummy_file"

sudo ln -sfv /media/sf_vagrant/lib /usr/lib/backup-util
sudo mkdir /etc/backup-util
sudo ln -sfv /media/sf_vagrant/examples/auth /etc/backup-util/auth
sudo ln -sfv /media/sf_vagrant/examples/targets /etc/backup-util/targets

echo "export PATH=\$PATH:/media/sf_vagrant/bin" | sudo tee -a "$HOME/.zshenv"
echo "export PATH=\$PATH:/media/sf_vagrant/bin" | sudo tee -a "$HOME/.bash_profile"

sudo sed -i 's/#local_enable=YES/local_enable=YES/' /etc/vsftpd.conf
sudo sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
sudo systemctl enable --now vsftpd.service
