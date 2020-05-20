SPK_NAME = sickchill
SPK_VERS = $(shell date +%Y%m%d)
SPK_REV = 7
SPK_ICON = src/sickchill.png

SPK_DEPENDS = "python>2.7.3-3:git"

MAINTAINER = miigotu
DESCRIPTION = Video File Manager for TV Shows. It watches for new episodes of your favorite shows and when they are posted it does its magic.
RELOAD_UI = yes
STARTABLE = yes
DISPLAY_NAME = SickChill
CHANGELOG = "Integrate with DSM5+6 Generic Service support for correct permissions."

HOMEPAGE   = https://sickchill.github.io
LICENSE    = GPL
HELPURL    = https://github.com/SickChill/SickChill

SERVICE_USER = auto
SERVICE_SETUP = src/service-setup.sh
SERVICE_PORT = 8081
SERVICE_PORT_TITLE = $(DISPLAY_NAME)

# Admin link for in DSM UI
ADMIN_PORT = $(SERVICE_PORT)

WIZARDS_DIR = src/wizard/

COPY_TARGET = nop
POST_STRIP_TARGET = sickchill_extra_install

# Pure Python package, make sure ARCH is not defined
override ARCH=

include ../../mk/spksrc.spk.mk

.PHONY: sickchill_extra_install
sickchill_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 600 src/config.ini $(STAGING_DIR)/var/config.ini
