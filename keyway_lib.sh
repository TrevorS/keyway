# Keyway - a simple lock file library.
# https://github.com/ATNI/keyway

# Practice safe bash scripting.
set -o errexit ; set -o nounset

# Customize the location of your lock files for this resource.
LOCK_DIR="locks"
# Set to true to supress log messages.
SILENT=false

# Check for locks and provide a warning during an abnormal exit.
trap "check_for_locks" SIGTERM SIGINT ERR

acquire_lock_for() {
  if create_lock $1; then
    check_execution "acquire lock"
    lock_log "Created $1 lock."
  else
    lock_log "Cannot run $1 -- application locked."
    exit 1
  fi
}

acquire_spinlock_for() {
  lock_log "Waiting on lock for $1."
  while :
  do
    if create_lock $1; then
      lock_log "Created $1 lock."
      break
    else
      sleep 1
    fi
  done
}

create_lock() {
  check_lock_dir
  ( set -o noclobber; echo "locked" > "$LOCK_DIR/$1".lock ) 2> /dev/null
}

release_lock_for() {
  lock_log "Releasing $1 lock."
  rm "$LOCK_DIR/$1".lock
  check_execution "release lock"
}

check_for_locks() {
  shopt -s nullglob
  if [[ ($LOCK_DIR/*.lock) ]]; then
    lock_log "Dirty exit -- lock files found in $LOCK_DIR."
    shopt -u nullglob && exit 3
  fi
  shopt -u nullglob
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
