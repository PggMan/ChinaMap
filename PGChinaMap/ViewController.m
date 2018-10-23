//
//  ViewController.m
//  ChinaMap
//
//  Created by 印度阿三 on 2018/10/22.
//  Copyright © 2018 印度阿三. All rights reserved.
//

#import "ViewController.h"
#import "PGChinaMap.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PGChinaMap *map = [[PGChinaMap alloc] initWithFrame:self.view.bounds];
    
    //map.seletedAry = @[@"新疆",@"黑龙江"];
    map.clickEnable = YES;
    [self.view addSubview:map];
}


@end
