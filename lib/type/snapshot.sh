
if ! check_variables_set "Source" "DestUrl" "SnapshotBase"; then
  print_error "Backup target '$1' does not define required properties 'Source', 'SnapshotBase' and 'DestUrl'"
  exit 2
fi

dest_fn="$1-$(date +"%Y%m%d-%H%M%S").tar.xz"

if [[ ! -d "$SnapshotBase" ]]; then
  mkdir -p "$SnapshotBase"
fi

if ! is_btrfs "$SnapshotBase"; then
  print_error "Snapshot directory '$SnapshotBase' is not a BTRFS"
  exit 3
fi
if ! is_btrfs "$Source" || ! is_btrfs_subvol_root "$Source"; then
  print_error "Source '$Source' must be the root of a BTRFS subvolume"
  exit 3
fi

snapshot_dest="$SnapshotBase/$dest_fn"
dest_url="$DestUrl/$dest_fn"

auth_param=""
if [[ -n "$User" ]] && [[ -n "$Password" ]]; then
  auth_param="-u ${User}:${Password}"
fi

# Finished config, doing backup now
sd_notify_ready

(
  create_btrfs_snapshot "$Source" "$snapshot_dest"

  tar -c --sparse --acls --selinux --xattrs -f - "$snapshot_dest" | \
  pv -pterb -s $(du -sb "$snapshot_dest" | awk '{print $1}') | \
  xz | \
  curl $auth_param -T - --ftp-create-dirs -s "$dest_url"

  delete_btrfs_snapshot "$snapshot_dest"
) &
bg_pid=$!

trap "kill $bg_pid 2> /dev/null" EXIT SIGHUP SIGINT SIGQUIT SIGTERM

# Satisfy watchdog
while kill -0 $bg_pid 2> /dev/null; do
  sd_notify_watchdog
  sleep 1
done

# Done with backup, tell systemd
sd_notify_stopping

# Disarm trap & retrieve job's exit code
trap - EXIT
wait $bg_pid
