# Keyway - a simple lock file library.
# https://github.com/ATNI/keyway

# Practice safe bash scripting.
set -o errexit ; set -o nounset

# Customize the location of your lock files for this resource.
LOCK_DIR="locks"
# Set to true to supress log messages.
SILENT=false

acquire_lock_for() {
  trap "release_lock_for $1; exit" SIGTERM SIGINT
  if not_locked $1; then
    lock_log "Creating $1 lock."
    touch "$LOCK_DIR/$1".lock
    check_execution "acquire lock"
  fi
}

acquire_spinlock_for() {
  lock_log "Waiting on lock for $1."
  while :
  do
    if lock_exists; then
      sleep 1
    else
      break
    fi
  done
  acquire_lock_for $1
}

release_lock_for() {
  lock_log "Releasing $1 lock."
  rm "$LOCK_DIR/$1".lock
  check_execution "release lock"
}

not_locked() {
  check_lock_dir
  if lock_exists; then
    lock_log "Cannot run $1 -- application locked by $LOCK_FILE."
    exit 1
  fi
}

lock_exists() {
  local exists=1
  for lock in "$LOCK_DIR"/*.lock
  do
    if [ -f $lock ]; then
      LOCK_FILE=$lock
      exists=0
      break
    fi
  done
  return $exists
}

check_lock_dir() {
  if [ ! -d $LOCK_DIR ]; then
    lock_log "Creating lock directory: $LOCK_DIR"
    mkdir -p $LOCK_DIR
    check_execution "create lock directory"
  fi
}

check_execution() {
  if [ $? -ne 0 ]; then
    lock_log "Could not $1, exiting."
    exit 2
  fi
}

lock_log() {
  if [ ! "$SILENT" == true ]; then
    local datetime=`date +"%Y-%m-%d %H:%M:%S"`
    printf "$datetime - Keyway: $1\n"
  fi
}
