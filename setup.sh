#!/usr/bin/env bash

set -e

LIB_DIR="/usr/lib/backup-util"
BIN_DIR="/usr/bin"
UNIT_DIR="/usr/lib/systemd/system"
SHARE_DIR="/usr/share/backup-util"

source_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

root_dir=""
symlink_param=""
verbose_param=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      root_dir="$2"
      shift
      ;;

    -s|--symlink)
      symlink_param="-s"
      ;;

    -v|--verbose)
      verbose_param="-v"
      ;;
  esac
  shift
done

if [[ -n "$root_dir" ]] && [[ ! -d "$root_dir" ]]; then
  echo "Root '$root_dir' is not a directory"
  exit 1
fi

lib_path="${root_dir}${LIB_DIR}"
bin_path="${root_dir}${BIN_DIR}"
unit_path="${root_dir}${UNIT_DIR}"
share_path="${root_dir}${SHARE_DIR}"

mkdir -p $verbose_param "$lib_path"
mkdir -p $verbose_param "$bin_path"
mkdir -p $verbose_param "$unit_path"
mkdir -p $verbose_param "$share_path"

cp -R $verbose_param $symlink_param "$source_dir/lib"/* "$lib_path"
cp -R $verbose_param $symlink_param "$source_dir/bin"/* "$bin_path"
cp -R $verbose_param $symlink_param "$source_dir/units"/* "$unit_path"
cp -R $verbose_param $symlink_param "$source_dir/examples" "$share_path"
