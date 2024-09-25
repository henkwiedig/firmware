################################################################################
#
# MSPOSD
#
################################################################################

MSPOSD_SITE_METHOD = git
MSPOSD_SITE = https://github.com/OpenIPC/msposd
MSPOSD_VERSION = main

MSPOSD_LICENSE = GPL-3.0
MSPOSD_LICENSE_FILES = LICENSE


MSPOSD_SRCS := compat.c msposd.c bmp/bitmap.c bmp/region.c bmp/lib/schrift.c bmp/text.c osd/net/network.c osd/msp/msp.c osd/msp/msp_displayport.c libpng/lodepng.c
MSPOSD_VERSION_STRING := $(shell date +"%Y%m%d_%H%M%S")



ifeq ($(BR2_OPENIPC_SOC_MODEL),"gk7205v300")

MSPOSD_DEPENDENCIES = libevent-openipc goke-osdrv-gk7205v200
MSPOSD_SDK := ./sdk/gk7205v300
MSPOSD_CFLAGS = -I $(MSPOSD_SDK)/include -O1 -g -fno-omit-frame-pointer -Wall -Wextra \
         -DVERSION_STRING="\"$(VERSION_STRING)\"" -D__GOKE__
MSPOSD_LDFLAGS = -L $(TARGET_DIR)/usr/lib -ldl -ldnvqe -lgk_api -lhi_mpi -lsecurec -lupvqe -lvoice_engine -ldnvqe -levent_core

else ifeq ($(BR2_OPENIPC_SOC_MODEL),"hi3516ev300")

MSPOSD_DEPENDENCIES = libevent-openipc hisilicon-osdrv-hi3516cv300 hisilicon-osdrv-hi3516ev200
MSPOSD_SDK := ./sdk/hi3516ev300
MSPOSD_CFLAGS = -I $(MSPOSD_SDK)/include -O1 -g -fno-omit-frame-pointer -Wall -Wextra \
         -DVERSION_STRING="\"$(VERSION_STRING)\"" -D__GOKE__
MSPOSD_LDFLAGS = -L $(TARGET_DIR)/usr/lib -ldnvqe -lmpi -lsecurec -lupvqe -lVoiceEngine -levent_core

else ifeq ($(BR2_OPENIPC_SOC_FAMILY),"infinity6e")

MSPOSD_DEPENDENCIES = libevent-openipc sigmastar-osdrv-infinity6e
MSPOSD_SDK := ./sdk/infinity6
MSPOSD_CFLAGS = -I $(MSPOSD_SDK)/include -O1 -g -fno-omit-frame-pointer -Wall -Wextra \
         -DVERSION_STRING="\"$(VERSION_STRING)\"" -D__SIGMASTAR__ -D__INFINITY6__ -D__INFINITY6E__
MSPOSD_LDFLAGS = -L $(TARGET_DIR)/usr/lib -lcam_os_wrapper -lm -lmi_rgn -lmi_sys -lmi_venc -levent_core

endif

define MSPOSD_BUILD_CMDS
    (echo $(BR2_OPENIPC_SOC_FAMILY); cd $(@D); $(TARGET_CC) $(MSPOSD_SRCS) $(MSPOSD_CFLAGS) $(MSPOSD_LDFLAGS) -o msposd)
endef

define MSPOSD_INSTALL_TARGET_CMDS
    $(INSTALL) -m 0755 -D $(@D)/msposd $(TARGET_DIR)/usr/bin/msposd

    curl -L -o $(TARGET_DIR)/usr/bin/font.png https://raw.githubusercontent.com/openipc/msposd/main/fonts/betaflight/font.png
    curl -L -o $(TARGET_DIR)/usr/bin/font_hd.png https://raw.githubusercontent.com/openipc/msposd/main/fonts/betaflight/font_hd.png
endef

$(eval $(generic-package))
