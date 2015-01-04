#!/usr/bin/env bash
source keyway_lib.sh

# Set our own test lock directory.
LOCK_DIR=test_locks

# Turn on silent mode so we can see our tests.
SILENT=true

# print a little information
echo
echo "Running Keyway Tests"
echo "--------------------"
echo

# prepare for the tests
if [ -d $LOCK_DIR ]; then
  echo "Removing existing lock directory."
  rm -rf $LOCK_DIR
fi

# test creation of lock directory
check_lock_dir
if [ -d $LOCK_DIR ]; then
  echo "Lock Directory: Passed"
else
  echo "Lock Directory: Failed"
fi

# test creation of lock file
acquire_lock_for "test"
if [ -f "$LOCK_DIR"/test.lock ]; then
  echo "Acquire Lock: Passed"
else
  echo "Acquire Lock: Failed"
fi

# test lock
if ! create_lock; then
  echo "Mutex: Passed"
else
  echo "Mutex: Failed"
fi

# test removal of lock file
release_lock_for "test"
if [ ! -f "$LOCK_DIR"/test.lock ]; then
  echo "Release Lock: Passed"
else
  echo "Release Lock: Failed"
fi

# clean up after the tests
echo "Cleaning up the test lock directory."
rm -rf $LOCK_DIR
