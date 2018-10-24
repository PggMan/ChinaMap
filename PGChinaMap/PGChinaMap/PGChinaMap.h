//
//  PGChinaMap.h
//  ChinaMap
//
//  Created by 印度阿三 on 2018/10/24.
//  Copyright © 2018 印度阿三. All rights reserved.
//

#import "PGModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PGChinaMap : UIView

/**配置模型*/
@property(nonatomic,strong) PGModel *model;

/**选中省份*/
@property(nonatomic,strong) NSArray <NSString *>*seletedAry;

/**点击地图功能 开启后关闭设置选中省份功能  默认 NO*/
@property(nonatomic,assign) BOOL clickEnable;

// 点击省份事件 只有当 clickEnable == YES 才响应
@property(nonatomic,copy) void(^clickActionBlock)(NSString *province);
@end

NS_ASSUME_NONNULL_END
