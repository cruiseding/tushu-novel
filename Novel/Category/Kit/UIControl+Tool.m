//
//  UIControl+Tool.m
//  xx
//
//  Created by xth on 2017/6/15.
//  Copyright © 2017年 th. All rights reserved.
//

#import "UIControl+Tool.h"

@implementation UIControl (Tool)

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_ignoreEvent = "UIControl_ignoreEvent";

- (NSTimeInterval)eventInterval {
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setEventInterval:(NSTimeInterval)eventInterval {
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)ignoreEvent{
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

- (void)setIgnoreEvent:(BOOL)ignoreEvent {
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(_fy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (void)_fy_sendAction:(SEL)selector to:(id)target forEvent:(UIEvent*)event{
    if (self.ignoreEvent) return;
    
    if (self.eventInterval > 0) {
        self.ignoreEvent = YES;
        [self performSelector:@selector(setIgnoreEvent:) withObject:@(NO) afterDelay:self.eventInterval];
    }
    
    [self _fy_sendAction:selector to:target forEvent:event];
}

@end
