//
//  MJDIYAutoFooter.m
//  MJRefreshExample
//
//  Created by MJ Lee on 15/6/13.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "MJDIYAutoFooter.h"

@interface MJDIYAutoFooter() {
    __unsafe_unretained YYAnimatedImageView *_loadingView;
}

@end

@implementation MJDIYAutoFooter

#pragma mark - 懒加载子控件
- (YYAnimatedImageView *)loadingView
{
    if (!_loadingView) {
        YYAnimatedImageView *loadingView = [[YYAnimatedImageView alloc] initWithImage:[YYImage imageNamed:@"refresh_loading"]];
        loadingView.hidden = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    self.backgroundColor = KbackgroundColor;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.mj_size = self.loadingView.image.size;
        self.loadingView.center = arrowCenter;
    }
    
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {//普通闲置状态
        if (oldState == MJRefreshStateRefreshing) {//正在刷新中的状态
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.hidden = YES;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.hidden = YES;
            }];
        } else {
            
        }
    } else if (state == MJRefreshStateRefreshing) {//正在刷新中的状态
        self.loadingView.hidden = NO; // 防止refreshing -> idle的动画完毕动作没有被执行
    }
}

@end
