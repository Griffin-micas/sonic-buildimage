# docker image for the clock feature (PTP / SyncE shared container)

DOCKER_CLOCK_STEM = docker-clock
DOCKER_CLOCK = $(DOCKER_CLOCK_STEM).gz
DOCKER_CLOCK_DBG = $(DOCKER_CLOCK_STEM)-$(DBG_IMAGE_MARK).gz

$(DOCKER_CLOCK)_PATH = $(DOCKERS_PATH)/docker-clock

# Runtime dependencies installed into the container image.
# clocksyncd is added here once the C++ daemon is implemented (separate step).
$(DOCKER_CLOCK)_DEPENDS += $(LINUXPTP)
$(DOCKER_CLOCK)_DEPENDS += $(LIBSWSSCOMMON) $(PYTHON3_SWSSCOMMON)

# clockcfgd Python wheel.
$(DOCKER_CLOCK)_PYTHON_WHEELS += $(SONIC_CLOCKCFGD_PY3)

$(DOCKER_CLOCK)_DBG_DEPENDS = $($(DOCKER_CONFIG_ENGINE_BOOKWORM)_DBG_DEPENDS)
$(DOCKER_CLOCK)_DBG_DEPENDS += $(LIBSWSSCOMMON_DBG)

$(DOCKER_CLOCK)_DBG_IMAGE_PACKAGES = $($(DOCKER_CONFIG_ENGINE_BOOKWORM)_DBG_IMAGE_PACKAGES)

$(DOCKER_CLOCK)_LOAD_DOCKERS += $(DOCKER_CONFIG_ENGINE_BOOKWORM)

$(DOCKER_CLOCK)_VERSION = 1.0.0
$(DOCKER_CLOCK)_PACKAGE_NAME = clock

SONIC_DOCKER_IMAGES += $(DOCKER_CLOCK)
ifeq ($(INCLUDE_CLOCK), y)
SONIC_INSTALL_DOCKER_IMAGES += $(DOCKER_CLOCK)
endif

SONIC_DOCKER_DBG_IMAGES += $(DOCKER_CLOCK_DBG)
ifeq ($(INCLUDE_CLOCK), y)
SONIC_INSTALL_DOCKER_DBG_IMAGES += $(DOCKER_CLOCK_DBG)
endif

$(DOCKER_CLOCK)_CONTAINER_NAME = clock
# Host network namespace is supplied by docker_image_ctl.j2 (--net=$NET) for
# global-scope containers, so it must NOT be repeated here; ptp4l still binds
# directly to front-panel interfaces.
# NET_ADMIN: SIOCSHWTSTAMP / DPLL netlink PIN_SET operations.
# NET_RAW:   raw Ethernet socket when network_transport=l2.
# /dev:      makes /dev/ptp* PHC and DPLL character devices visible.
# device-cgroup-rule: -v /dev:/dev only makes the nodes visible; under cgroup v2
#   the device controller still denies open() of char devices not on the default
#   allowlist, so ptp4l/clocksyncd get EPERM on /dev/ptp*. PHC majors are
#   dynamically allocated (no stable major to scope to), and business-port PHCs
#   add more /dev/ptp* nodes later, so we grant all char devices ('c *:* rwm')
#   rather than per-device --device flags.
$(DOCKER_CLOCK)_RUN_OPT += -t
$(DOCKER_CLOCK)_RUN_OPT += --cap-add=NET_ADMIN --cap-add=NET_RAW
$(DOCKER_CLOCK)_RUN_OPT += -v /etc/sonic:/etc/sonic:ro
$(DOCKER_CLOCK)_RUN_OPT += -v /etc/localtime:/etc/localtime:ro
$(DOCKER_CLOCK)_RUN_OPT += -v /dev:/dev
$(DOCKER_CLOCK)_RUN_OPT += --device-cgroup-rule='c *:* rwm'

SONIC_BOOKWORM_DOCKERS += $(DOCKER_CLOCK)
SONIC_BOOKWORM_DBG_DOCKERS += $(DOCKER_CLOCK_DBG)
