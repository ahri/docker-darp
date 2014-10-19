#!/bin/sh
exec /sbin/setuser $DAEMON_USER $DAEMON_BIN >> /var/log/`basename $DAEMON_BIN`.log 2>&1
