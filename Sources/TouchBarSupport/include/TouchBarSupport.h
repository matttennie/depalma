#import <AppKit/AppKit.h>

FOUNDATION_EXPORT void TouchBarShowCloseBoxWhenFrontMost(BOOL showing);
FOUNDATION_EXPORT void TouchBarSetControlStripPresence(NSTouchBarItemIdentifier identifier, BOOL present);
FOUNDATION_EXPORT void TouchBarAddSystemTrayItem(NSCustomTouchBarItem *item);
FOUNDATION_EXPORT void TouchBarRemoveSystemTrayItem(NSCustomTouchBarItem *item);
