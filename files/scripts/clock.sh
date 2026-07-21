#!/bin/bash

# Host-side wrapper for the clock (PTP / SyncE) feature service.
# Invoked by clock.service; delegates docker lifecycle to the generated
# /usr/bin/clock.sh control script (rendered from docker_image_ctl.j2).
# clock is a global-scope, single-instance feature, so there is no ASIC
# namespace handling here. stop() performs a graceful docker stop so the
# clocksyncd SIGTERM handler can reset the 1PPS pin direction and clean up
# STATE_DB.PTP_*_TABLE before exit.

function debug()
{
    /usr/bin/logger $1
    /bin/echo `date` "- $1" >> ${DEBUGLOG}
}

start() {
    debug "Starting ${SERVICE} service..."

    /usr/bin/${SERVICE}.sh start
    debug "Started ${SERVICE} service..."
}

wait() {
    /usr/bin/${SERVICE}.sh wait
}

stop() {
    debug "Stopping ${SERVICE} service..."

    /usr/bin/${SERVICE}.sh stop
    debug "Stopped ${SERVICE} service..."
}

SERVICE="clock"
DEBUGLOG="/tmp/clock-debug.log"

case "$1" in
    start|wait|stop)
        $1
        ;;
    *)
        echo "Usage: $0 {start|wait|stop}"
        exit 1
        ;;
esac
