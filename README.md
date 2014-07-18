```
dP
88
88  .dP  .d8888b. dP    dP dP  dP  dP .d8888b. dP    dP
88888"   88ooood8 88    88 88  88  88 88'  `88 88    88
88  `8b. 88.  ... 88.  .88 88.88b.88' 88.  .88 88.  .88
dP   `YP `88888P' `8888P88 8888P Y8P  `88888P8 `8888P88
                       .88                          .88
                   d8888P                       d8888P
```
### Keyway
A simple lock file library.

###### Features
* Provides mutual exclusion for scripts that require the same resource.
* Requires only two additional lines of code in your script besides sourcing the library.
* Scripts using Keyway will either terminate or busy-wait for a resource if blocked.
* Keyway will clean up locks created by scripts that have been early-terminated by `SIGINT` or `SIGTERM`.

###### Usage:
* `acquire_lock_for "your_task_name"`
  * If the resource is not locked, your task will execute, otherwise it will terminate.
* `acquire_spinlock_for "your_task_name"`
  * If the resource is locked, your task will wait until the lock has been released before acquiring its own lock and executing.

###### Return Code Explanations:
1. Your application was not able to acquire lock.
2. There was some other problem:
     * Keyway could not create the lock directory.
     * Keyway could not create or remove a lock.

###### An example:
```bash
#!/bin/bash
source keyway_lib.sh

# optionally override the lock file directory
LOCK_DIR="alt-lock-dir"

# attempt to lock the shared resource
acquire_lock_for "your_task_name"

# if the lock was successful, execute the task
echo "executing critical section"

# release the lock when the task is done
release_lock_for "your_task_name"
```
