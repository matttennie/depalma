//
//  main.c
//  TouchGuard
//
//  Created by SyntaxSoft 2016.
//

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <strings.h>
#include <ApplicationServices/ApplicationServices.h>
#include <CoreFoundation/CoreFoundation.h>

#define MAJOR_VERSION  2
#define MINOR_VERSION  0

static bool debugLogging = true;
static bool blockerEnabled = true;
static uint64_t blockedClickCount = 0;
static CFMachPortRef eventTap = NULL;

static bool isBlockedClickEvent(CGEventType type)
{
    return type == kCGEventLeftMouseDown
        || type == kCGEventLeftMouseUp
        || type == kCGEventRightMouseDown
        || type == kCGEventRightMouseUp
        || type == kCGEventOtherMouseDown
        || type == kCGEventOtherMouseUp;
}

static const char *eventTypeName(CGEventType type)
{
    switch (type) {
        case kCGEventLeftMouseDown: return "LeftMouseDown";
        case kCGEventLeftMouseUp: return "LeftMouseUp";
        case kCGEventRightMouseDown: return "RightMouseDown";
        case kCGEventRightMouseUp: return "RightMouseUp";
        case kCGEventOtherMouseDown: return "OtherMouseDown";
        case kCGEventOtherMouseUp: return "OtherMouseUp";
        default: return "Other";
    }
}

static void enableTapIfNeeded(void)
{
    if (eventTap != NULL) {
        CGEventTapEnable(eventTap, true);
    }
}

static CGEventRef eventCallBack(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    (void)proxy;
    (void)refcon;

    if (type == kCGEventTapDisabledByTimeout || type == kCGEventTapDisabledByUserInput) {
        if (debugLogging) {
            fprintf(stderr, "Event tap disabled by system, re-enabling\n");
        }
        enableTapIfNeeded();
        return event;
    }

    if (!blockerEnabled || !isBlockedClickEvent(type)) {
        return event;
    }

    blockedClickCount += 1;
    if (debugLogging) {
        fprintf(stderr, "Blocked %s (%llu total)\n", eventTypeName(type), blockedClickCount);
    }
    return NULL;
}

int main(int argc, const char * argv[])
{
    CFRunLoopSourceRef eventRunLoop = NULL;
    CGEventMask mask = 0;

    for (int count = 1; count < argc; count += 1) {
        if (strcasecmp("-nodebug", argv[count]) == 0) {
            debugLogging = false;
        } else if (strcasecmp("-version", argv[count]) == 0) {
            printf("Version %d.%d\n", MAJOR_VERSION, MINOR_VERSION);
            return 0;
        } else if (strcasecmp("-disabled", argv[count]) == 0) {
            blockerEnabled = false;
        } else {
            fprintf(stderr, "Unknown argument: %s\n", argv[count]);
            return 1;
        }
    }

    mask |= CGEventMaskBit(kCGEventLeftMouseDown);
    mask |= CGEventMaskBit(kCGEventLeftMouseUp);
    mask |= CGEventMaskBit(kCGEventRightMouseDown);
    mask |= CGEventMaskBit(kCGEventRightMouseUp);
    mask |= CGEventMaskBit(kCGEventOtherMouseDown);
    mask |= CGEventMaskBit(kCGEventOtherMouseUp);

    if (debugLogging) {
        fprintf(stderr, "Click blocker %s\n", blockerEnabled ? "enabled" : "disabled");
    }

    eventTap = CGEventTapCreate(
        kCGHIDEventTap,
        kCGHeadInsertEventTap,
        kCGEventTapOptionDefault,
        mask,
        eventCallBack,
        NULL
    );

    if (eventTap == NULL) {
        fprintf(stderr, "Failed to create event tap\n");
        return 1;
    }

    eventRunLoop = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), eventRunLoop, kCFRunLoopCommonModes);
    CGEventTapEnable(eventTap, true);

    CFRunLoopRun();
    return 0;
}
