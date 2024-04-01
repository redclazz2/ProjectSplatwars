#macro IS_DEBUG							0
#macro PLATFORM_TARGET					1

#macro DesktopRelease:PLATFORM_TARGET	0
#macro DesktopRelease:IS_DEBUG			0
#macro DesktopDebug:IS_DEBUG			1
#macro DesktopDebug:PLATFORM_TARGET	    0

#macro MobileRelease:PLATFORM_TARGET	1
#macro MobileRelease:IS_DEBUG			0
#macro MobileDebug:IS_DEBUG				1
#macro MobileDebug:PLATFORM_TARGET	    1