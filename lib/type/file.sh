
if ! check_variables_set "Source" "DestUrl"; then
  print_error "Backup target '$1' does not define required properties 'Source' and 'DestUrl'"
  exit 2
fi

auth_param=""
if [[ -n "$User" ]] && [[ -n "$Password" ]]; then
  auth_param="-u ${User}:${Password}"
fi

dest_fn="$1-$(date +"%Y%m%d-%H%M%S").tar.xz"
dest_url="$DestUrl/$dest_fn"

tar -c --sparse --acls --selinux --xattrs -f - "$Source" | \
pv -pterb -s $(du -sb "$Source" | awk '{print $1}') | \
xz | \
curl $auth_param -T - --ftp-create-dirs -s "$dest_url"
