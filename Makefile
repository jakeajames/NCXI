include $(THEOS)/makefiles/common.mk

ARCHS=armv7 arm64
export TARGET = iphone:10.1:10.0

TWEAK_NAME = NotificationCenterXI
NotificationCenterXI_FILES = $(wildcard *.xm) $(wildcard *.m)
NotificationCenterXI_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
