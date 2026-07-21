# clockcfgd python3 wheel
#
# clockcfgd is the PTP configuration daemon that runs inside docker-clock.
# It owns ptp4l.conf rendering, ptp4l lifecycle, and the
# PTP_VALIDATION_TABLE in STATE_DB. See doc/ptp/PTP_LLD.md.
#
# Source lives in the sonic-clock submodule under clockcfgd/. The same
# submodule will also hold clocksyncd (C++ deb, future) and esmcd
# (colleague's SyncE daemon), each with its own rules file.

SONIC_CLOCKCFGD_PY3 = sonic_clockcfgd-1.0.0-py3-none-any.whl
$(SONIC_CLOCKCFGD_PY3)_SRC_PATH = $(SRC_PATH)/sonic-clock/clockcfgd
$(SONIC_CLOCKCFGD_PY3)_PYTHON_VERSION = 3
$(SONIC_CLOCKCFGD_PY3)_DEPENDS += $(SONIC_PY_COMMON_PY3)
$(SONIC_CLOCKCFGD_PY3)_DEBS_DEPENDS += $(LIBSWSSCOMMON) $(PYTHON3_SWSSCOMMON)
SONIC_PYTHON_WHEELS += $(SONIC_CLOCKCFGD_PY3)
