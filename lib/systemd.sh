
sd_notify() {
  if [[ $ARG_USE_SYSTEMD -ne 1 ]]; then
    return
  fi
  systemd-notify $@
}

sd_notify_ready() {
  sd_notify --ready
}

sd_notify_watchdog() {
  sd_notify "WATCHDOG=1"
}

sd_notify_stopping() {
  sd_notify "STOPPING=1"
}
