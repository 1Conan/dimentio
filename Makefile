include $(THEOS)/makefiles/common.mk

ARCHS = armv7 arm64 arm64e

ifeq ($(THEOS_LINKAGE_TYPE),dynamic)
SOVERSION = .0
else
SOVERSION =
endif

LIBRARY_NAME = libdimentio$(SOVERSION)
libdimentio$(SOVERSION)_FILES = src/libdimentio.c
libdimentio$(SOVERSION)_FRAMEWORKS = IOKit

TOOL_NAME = dimentio
dimentio_FILES = src/dimentio.c
dimentio_LDFLAGS = -L$(THEOS_OBJ_DIR)
dimentio_CODESIGN_FLAGS = -Ssrc/tfp0.plist
dimentio_LIBRARIES = dimentio$(SOVERSION)

ifeq ($(THEOS_LINKAGE_TYPE),static) # No need to link twice if not a static build!
dimentio_FRAMEWORKS = IOKit
endif

include $(THEOS_MAKE_PATH)/library.mk
include $(THEOS_MAKE_PATH)/tool.mk

# Ideally library and header files are split into debian-esque packages, but this will have to do for a theos build!
after-stage::
	mkdir -p $(THEOS_STAGING_DIR)/usr/include
	cp $(THEOS_BUILD_DIR)/src/libdimentio.h $(THEOS_STAGING_DIR)/usr/include
	chmod u+s $(THEOS_STAGING_DIR)/usr/bin/dimentio
ifeq ($(THEOS_LINKAGE_TYPE),dynamic)
	ln -s libdimentio$(SOVERSION).dylib $(THEOS_STAGING_DIR)/usr/lib/libdimentio.dylib
endif