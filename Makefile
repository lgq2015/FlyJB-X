GO_EASY_ON_ME = 1
FINALPACKAGE=1
DEBUG=0

THEOS_DEVICE_IP = 10.42.0.33 -p 2222

ARCHS := arm64
TARGET := iphone:clang:13.1:7.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = FlyJBX
$(TWEAK_NAME)_FRAMEWORKS = MobileCoreServices Dobby
$(TWEAK_NAME)_LIBRARIES = MobileGestalt rocketbootstrap
$(TWEAK_NAME)_PRIVATE_FRAMEWORKS = AppSupport
$(TWEAK_NAME)_FILES = fishhook/fishhook.c Tweaks/FJPattern.xm Tweaks/Tweak.xm Tweaks/LibraryHooks.xm Tweaks/ObjCHooks.xm Tweaks/DisableInjector.xm Tweaks/SysHooks.xm Tweaks/NoSafeMode.xm Tweaks/MemHooks.xm Tweaks/OptimizeHooks.xm Tweaks/CheckHooks.xm Tweaks/PatchFinder.xm Tweaks/AeonLucid.xm
$(TWEAK_NAME)_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += FlyJBXPrefs FJHooker
include $(THEOS_MAKE_PATH)/aggregate.mk
