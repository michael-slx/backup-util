
check_variables_set() {
  while test $# -gt 0
  do
    if [[ -z "${!1}" ]]; then
      return 1
    fi
    shift
  done
  return 0
}
