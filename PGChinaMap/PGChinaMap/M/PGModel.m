//
//  PGModel.m
//  ChinaMap
//
//  Created by 印度阿三 on 2018/10/24.
//  Copyright © 2018 印度阿三. All rights reserved.
//

#import "PGModel.h"

@implementation PGModel
- (UIColor *)backColorD{
    
    
    return _backColorD != nil ? _backColorD:[UIColor greenColor];
}

- (UIColor *)backColorH{
    
    
    return _backColorH != nil ? _backColorH:[UIColor redColor];
}

- (UIColor *)nameColor{
    
    
    return _nameColor != nil ? _nameColor:[UIColor darkTextColor];
}
- (UIFont *)nameFont{
    
    
    return _nameFont ? _nameFont:[UIFont systemFontOfSize:13];
}

- (UIColor *)viewColor{
    
    
    return _viewColor != nil ? _viewColor:[UIColor grayColor];
}

@end
