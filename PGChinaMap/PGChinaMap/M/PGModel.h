//
//  PGModel.h
//  ChinaMap
//
//  Created by 印度阿三 on 2018/10/24.
//  Copyright © 2018 印度阿三. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 用于设置地图信息
@interface PGModel : NSObject

/**view控件 背景颜色*/
@property(nonatomic,strong) UIColor *viewColor;

/**背景色 默认*/
@property(nonatomic,strong) UIColor *backColorD;

/**背景色 高亮*/
@property(nonatomic,strong) UIColor *backColorH;

/**省份名字 字号 建议不要大于13*/
@property(nonatomic,strong) UIFont *nameFont;

/**省份名字 颜色*/
@property(nonatomic,strong) UIColor *nameColor;

/**省份边界线 颜色*/
@property(nonatomic,strong) UIColor *lineColor;
@end

NS_ASSUME_NONNULL_END
