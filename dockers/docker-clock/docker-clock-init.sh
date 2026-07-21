#!/usr/bin/env bash
# Container entrypoint: render supervisord.conf from the Jinja2 template and
# exec supervisord. This is the only process that runs as PID 1.
mkdir -p /etc/supervisor/conf.d/
sonic-cfggen -d -a "{\"namespace_id\":\"$NAMESPACE_ID\"}" \
    -t /usr/share/sonic/templates/supervisord.conf.j2 \
    > /etc/supervisor/conf.d/supervisord.conf
exec /usr/local/bin/supervisord
