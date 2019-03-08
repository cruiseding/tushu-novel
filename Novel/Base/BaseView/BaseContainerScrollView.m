//
//  xxContainerScrollView.m
//  Novel
//
//  Created by xth on 2018/1/8.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseContainerScrollView.h"

@implementation BaseContainerScrollView

- (void)dealloc {
    NSLog(@"%@ 释放了",NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}


////一句话总结就是此方法返回YES时，手势事件会一直往下传递，不论当前层次是否对该事件进行响应。
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//
//    if ([self panBack:gestureRecognizer]) {
//        return YES;
//    }
//    return NO;
//
//}
//
////location_X可自己定义,其代表的是滑动返回距左边的有效长度
//- (BOOL)panBack:(UIGestureRecognizer *)gestureRecognizer {
//
//    int location_X = 100;
//
//    if (gestureRecognizer == self.panGestureRecognizer) {
//        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//        CGPoint point = [pan translationInView:self];
//        UIGestureRecognizerState state = gestureRecognizer.state;
//        if (UIGestureRecognizerStateBegan == state || UIGestureRecognizerStatePossible == state) {
//            CGPoint location = [gestureRecognizer locationInView:self];
//            if (point.x > 0 && location.x < location_X && self.contentOffset.x <= 0) {
//                return YES;
//            }
//        }
//    }
//    return NO;
//
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
