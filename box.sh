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

mkdir -p "/tmp/$(whoami)"

dummy_file="/tmp/$(whoami)/backup_dummy"
head -c 512M </dev/urandom >"$dummy_file"
sudo cp -v "$dummy_file" "/mnt/data/root/subvol/file1"
sudo cp -v "$dummy_file" "/mnt/data/root/subvol/file2"
rm -v "$dummy_file"

dummy_db="/tmp/$(whoami)/example.sdb"
curl "https://raw.githubusercontent.com/lerocha/chinook-database/master/ChinookDatabase/DataSources/Chinook_Sqlite_AutoIncrementPKs.sqlite" > $dummy_db
sudo cp -v $dummy_db "/mnt/data/root/subvol/example.sdb"
sudo rm -v $dummy_db

sudo sed -i 's/#local_enable=YES/local_enable=YES/' /etc/vsftpd.conf
sudo sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
sudo systemctl enable --now vsftpd.service

sudo /media/sf_vagrant/setup.sh -s -v
sudo ln -sf /usr/share/backup-util/examples /etc/backup-util
