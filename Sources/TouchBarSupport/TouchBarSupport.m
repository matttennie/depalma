#import "TouchBarSupport.h"
#import <dlfcn.h>

typedef void (*TouchBarShowCloseBoxFn)(BOOL);
typedef void (*TouchBarSetPresenceFn)(NSTouchBarItemIdentifier, BOOL);

void TouchBarShowCloseBoxWhenFrontMost(BOOL showing) {
    TouchBarShowCloseBoxFn fn = (TouchBarShowCloseBoxFn)dlsym(RTLD_DEFAULT, "DFRSystemModalShowsCloseBoxWhenFrontMost");
    if (fn) {
        fn(showing);
    }
}

void TouchBarSetControlStripPresence(NSTouchBarItemIdentifier identifier, BOOL present) {
    TouchBarSetPresenceFn fn = (TouchBarSetPresenceFn)dlsym(RTLD_DEFAULT, "DFRElementSetControlStripPresenceForIdentifier");
    if (fn) {
        fn(identifier, present);
    }
}

void TouchBarAddSystemTrayItem(NSCustomTouchBarItem *item) {
    Class cls = [NSTouchBarItem class];
    SEL selector = NSSelectorFromString(@"addSystemTrayItem:");
    if ([cls respondsToSelector:selector]) {
        ((void (*)(id, SEL, id))[cls methodForSelector:selector])(cls, selector, item);
    }
}

void TouchBarRemoveSystemTrayItem(NSCustomTouchBarItem *item) {
    Class cls = [NSTouchBarItem class];
    SEL selector = NSSelectorFromString(@"removeSystemTrayItem:");
    if ([cls respondsToSelector:selector]) {
        ((void (*)(id, SEL, id))[cls methodForSelector:selector])(cls, selector, item);
    }
}
