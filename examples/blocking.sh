#!/usr/bin/env bash

# load keyway
source keyway_lib.sh

# acquire a regular lock and release it
acquire_lock_for "regular"
echo "regular lock critical section"
release_lock_for "regular"

# acquire a regular lock and block
acquire_lock_for "blocking"
echo "blocking lock critical section"
sleep 30
release_lock_for "blocking"
