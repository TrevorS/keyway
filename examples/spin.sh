#!/usr/bin/env bash

# load keyway
source keyway_lib.sh

# acquire a spinlock
acquire_spinlock_for "blocking"

# if the blocking example is running, this script will wait
# to enter the critical section
echo "in"

# release the lock
release_lock_for "blocking"
