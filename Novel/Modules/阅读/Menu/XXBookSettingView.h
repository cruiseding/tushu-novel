//
//  XXBookSettingView.h
//  Novel
//
//  Created by app on 2018/1/22.
//  Copyright © 2018年 th. All rights reserved.
//

#import "BaseView.h"

@interface XXBookSettingView : BaseView


/**
 设置颜色选择

 @param index <#index description#>
 */
- (void)refreshColorSeleted:(NSUInteger)index;

/** 字体缩小 */
@property (nonatomic, copy) void(^changeSmallerFontBlock)();

/** 字体放大 */
@property (nonatomic, copy) void(^changeBiggerFontBlock)();

/** 横竖屏切换 */
//@property (nonatomic, copy) void(^landspaceBlock)();

@end
