
temp_dir() {
  mkdir -p "/tmp/$USER/$$"
  echo "/tmp/$USER/$$"
}

runtime_dir() {
  local base_dir="$XDG_RUNTIME_DIR"
  if [[ -z "$base_dir" ]]; then
    base_dir="$(temp_dir)/runtime-$USER"
    print_warning "XDG_RUNTIME_DIR not set or empty! Defaulting to $base_dir"
  fi
  mkdir -p "$base_dir/$$"
  echo "$base_dir/$$"
}
