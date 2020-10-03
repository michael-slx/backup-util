
BTRFS="btrfs -v"
BTRFS_SUBVOL="$BTRFS subvolume"
BTRFS_CREATE_SNAP="$BTRFS_SUBVOL snapshot -r"
BTRFS_DELETE_SNAP="$BTRFS_SUBVOL delete"

STAT_INODE="stat --format=%i"
STAT_FSTYPE="stat -f --format=%T"

is_btrfs() {
  fstype="$($STAT_FSTYPE "$1")"
  [[ "$fstype" == "btrfs" ]]
}

is_btrfs_subvol_root() {
  inode="$($STAT_INODE "$1")"
  [[ $inode -eq 256 ]]
}

create_btrfs_snapshot() {
  local source="$1"
  local dest="$2"
  $BTRFS_CREATE_SNAP "$source" "$dest"
}

delete_btrfs_snapshot() {
  local subvol="$1"
  $BTRFS_DELETE_SNAP "$subvol"
}
