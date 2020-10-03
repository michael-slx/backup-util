
temp_dir() {
  echo "/tmp"
}

runtime_dir() {
  local base_dir="$XDG_RUNTIME_DIR"
  if [[ -z "$base_dir" ]]; then
    base_dir="$(temp_dir)/runtime-$USER"
    print_warning "XDG_RUNTIME_DIR not set or empty! Defaulting to $base_dir"
  fi
  echo "$base_dir/$$"
}
