#!/usr/bin/env bash
# One-shot container bootstrap script executed by supervisord before any clock
# daemon starts. Creates required runtime directories and performs basic sanity
# checks. Exits 0 on success; supervisord treats a non-zero exit as a fatal
# startup failure for the dependent-startup chain.

CTR_SCRIPT="/usr/share/sonic/scripts/container_startup.py"
if [ -f "${CTR_SCRIPT}" ]; then
    ${CTR_SCRIPT} -f clock -o "${RUNTIME_OWNER:-kube}" -v "${IMAGE_VERSION}"
fi

# Runtime directories used by ptp4l (UDS socket) and clocksyncd (UDS server)
mkdir -p /var/run
mkdir -p /var/log

# Config directories for the clock daemons, each grouped under its own
# /etc subdir (the same way SNMP keeps configs under /etc/snmp): linuxptp
# configs (ptp4l.conf) under /etc/linuxptp, and the standalone SyncE daemon
# esmcd's synce.conf under /etc/synce. Both are rendered by clockcfgd.
mkdir -p /etc/linuxptp /etc/synce

# Sentinel consumed by sonic-config-engine health checks
mkdir -p /var/sonic
echo "# Config files managed by sonic-config-engine" > /var/sonic/config_status

# Remove any stale ptp4l UDS socket left from a previous unclean shutdown so
# clocksyncd's reachability probe does not see a dangling socket on startup.
rm -f /var/run/ptp4l
