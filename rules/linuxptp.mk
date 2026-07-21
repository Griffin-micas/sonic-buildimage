# linuxptp package (upstream 4.2, Debian revision 1)
# src/linuxptp/Makefile fetches the Debian source via dget at build time,
# applies SONiC patches from src/linuxptp/patch/, and runs dpkg-buildpackage.

LINUXPTP_VERSION = 4.2
LINUXPTP_VERSION_SUFFIX = 1
LINUXPTP_VERSION_FULL = $(LINUXPTP_VERSION)-$(LINUXPTP_VERSION_SUFFIX)

LINUXPTP = linuxptp_$(LINUXPTP_VERSION_FULL)_$(CONFIGURED_ARCH).deb
$(LINUXPTP)_SRC_PATH = $(SRC_PATH)/linuxptp
# linuxptp 4.2-1 is built from source (dget from deb.debian.org directly,
# because SONiC's curated mirror only carries an older version — see
# src/linuxptp/Makefile). The source package Build-Depends only on
# debhelper-compat (= 13) and links libc alone (no libmnl), so it builds
# cleanly in both the bookworm and trixie slaves. We therefore build it in
# every enabled BLDENV (no distro gate); docker-clock consumes the deb from
# the tree matching its own base distro (bookworm — see rules/docker-clock.mk).
SONIC_MAKE_DEBS += $(LINUXPTP)

LINUXPTP_DBG = linuxptp-dbgsym_$(LINUXPTP_VERSION_FULL)_$(CONFIGURED_ARCH).deb
$(eval $(call add_derived_package,$(LINUXPTP),$(LINUXPTP_DBG)))

export LINUXPTP_VERSION
export LINUXPTP_VERSION_FULL
export LINUXPTP
export LINUXPTP_DBG

DBG_SRC_ARCHIVE += linuxptp
