//
//  PGChinaMap.m
//  ChinaMap
//
//  Created by 印度阿三 on 2018/10/24.
//  Copyright © 2018 印度阿三. All rights reserved.
//

#import "PGChinaMap.h"
@interface PGChinaMap ()
/**地图块贝塞尔曲线数组*/
@property(nonatomic,strong) NSMutableArray <UIBezierPath *>*pathAry;
/**地图块贝塞尔曲线数组*/
@property (nonatomic,strong) NSMutableArray <UIColor *>*colorAry;
/**各个省级行政区名字及位置数组*/
@property (nonatomic,strong) NSMutableArray <NSDictionary *>*textAry;
/**选中的地图块*/
@property (nonatomic,assign) NSUInteger seletedIdx;
/**省名对应的序号*/
@property(nonatomic,strong) NSDictionary *nameIndexDic;

/**省名序号对应的名字*/
@property(nonatomic,strong) NSDictionary *indexNameDic;
@end

@implementation PGChinaMap

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = self.model.viewColor;
        
        CGFloat w = frame.size.width;
        CGFloat scale = w/560.;
        self.transform = CGAffineTransformMakeScale(scale, scale);//宽高伸缩比例
        self.frame = CGRectMake(0, 0, w, w * 321.43 / 375.0);
        self.center = CGPointMake(w *0.5,frame.size.height *0.5);
        
        self.clickEnable = NO;
    }
    return self;
}

- (void)setSeletedAry:(NSArray<NSString *> *)seletedAry{
    _seletedAry = seletedAry;
    if (self.clickEnable == YES) return;
    
    _colorAry = nil; // 清空上次绘制的
    if (self.gestureRecognizers.count >0) self.gestureRecognizers = @[];
    [self selectAction:self.seletedAry];
}

- (void)setClickEnable:(BOOL)clickEnable{
    _clickEnable = clickEnable;
    
    if (clickEnable == NO) {
        if (self.gestureRecognizers.count >0) self.gestureRecognizers = @[];
        [self selectAction:self.seletedAry];
    }else{
        if (self.gestureRecognizers.count >0)return;
        
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:click];
        
    }
    
    
    
    
}

#pragma mark - Action
- (void)click:(UITapGestureRecognizer *)sender{
    CGPoint point = [sender locationInView:sender.view];
    [self tap:point];
    
}


// 绘制选中区域颜色
- (void)tap:(CGPoint)point{
    //遍历34个地图块.判断点击的是那一块
    for (int i = 0; i <34; i++) {
        UIBezierPath *path = self.pathAry[i];
        BOOL isInPath = [path containsPoint:point];
        if (isInPath) {
            //清除之前选中的颜色，fill当前选中的颜色
            self.colorAry[_seletedIdx]  = self.model.backColorD;
            _seletedIdx = i;
            self.colorAry[_seletedIdx]  = self.model.backColorH;
            [self setNeedsDisplay];
            
            NSString *province = [self.indexNameDic objectForKey:[NSString stringWithFormat:@"%ld",_seletedIdx]];
            !self.clickActionBlock?:self.clickActionBlock(province);
        }
    }
}

- (void)selectAction:(NSArray <NSString *>*)seletedAry{
    
    if (seletedAry.count <= 0) return;
    
    for (int i = 0; i < seletedAry.count; i++) {
        NSString *name = [self.seletedAry objectAtIndex:i];
        if (name.length <= 0) return;
        
        NSString *value = [self.nameIndexDic objectForKey:name];
        NSString *desc = [NSString stringWithFormat:@"请传入正确省份名, 此 %@ 不正确",name];
        NSAssert((value.integerValue - 1) >= 0,desc);
        if ((value.integerValue - 1) < 0) return;
        
        NSInteger index = value.integerValue - 1;
        self.colorAry[index] = self.model.backColorH;
    }
    [self setNeedsDisplay];
    
    
}

// 画地图
- (void)drawRect:(CGRect)rect{
    // 边线颜色
    UIColor* strokeColor = self.model.lineColor;
    
    [self.pathAry enumerateObjectsUsingBlock:^(UIBezierPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.miterLimit = 4;
        obj.lineJoinStyle = kCGLineJoinRound;
        [self.colorAry[idx] setFill];
        [obj fill];
        [strokeColor setStroke];
        obj.lineWidth = 1;
        [obj stroke];
    }];
    
    // 绘制文字
    __weak typeof(self) weakSelf = self;
    [self.textAry enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *name = obj[@"name"];
        NSValue *rectValue = obj[@"rect"];
        [weakSelf drawText:name rect:rectValue];
    }];
}


- (void)drawText:(NSString *)name rect:(NSValue *)rect{
    CGRect textRect = [rect CGRectValue];
    {
        NSString *textContent = name;
        CGContextRef context = UIGraphicsGetCurrentContext();
        NSMutableParagraphStyle *textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentLeft;
        // 省份名字: 字号 颜色 段落样式
        NSDictionary *dic = @{
                              NSFontAttributeName: [UIFont systemFontOfSize: 13]
                              , NSForegroundColorAttributeName: UIColor.blackColor, NSParagraphStyleAttributeName: textStyle
                              };
        
        CGFloat textH = [textContent boundingRectWithSize: CGSizeMake(textRect.size.width, INFINITY)  options: NSStringDrawingUsesLineFragmentOrigin attributes: dic context: nil].size.height;
        
        CGContextSaveGState(context);
        CGContextClipToRect(context, textRect);
        [textContent drawInRect: CGRectMake(CGRectGetMinX(textRect), CGRectGetMinY(textRect) + (CGRectGetHeight(textRect) - textH) / 2, CGRectGetWidth(textRect), textH) withAttributes: dic];
        CGContextRestoreGState(context);
    }
}

#pragma mark - 懒加载
- (PGModel *)model{
    
    if (!_model) {
        _model = [[PGModel alloc] init];
    }
    
    return _model;
}

-(NSMutableArray<UIBezierPath *> *)pathAry{
    if (_pathAry == nil) {
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"ChinaMapPaths" ofType:@"plist"];
        NSData *pathsData = [NSData dataWithContentsOfFile:sourcePath];
        _pathAry = [NSKeyedUnarchiver unarchiveObjectWithData:pathsData];
        
    }
    return _pathAry;
}


- (NSMutableArray *)colorAry{
    if (_colorAry == nil) {
        _colorAry = [NSMutableArray arrayWithCapacity:34];
        for (int i = 0; i <34; i++) {
            UIColor* fillColor = self.model.backColorD;
            [_colorAry addObject:fillColor];
        }
    }
    return _colorAry;
}

- (NSMutableArray *)textAry{
    if (_textAry != nil) {
        return _textAry;
    }
    
    return [self readFromDisk];
    
    
}

// plist文件读取省份名字
- (NSMutableArray *)readFromDisk{
    
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"ProvincialName" ofType:@"plist"];
    NSData *data = [NSData dataWithContentsOfFile:sourcePath];
    NSMutableArray *nameAry = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return nameAry;
    
}

// 序号从1开始 避免无内容key查到0
- (NSDictionary *)nameIndexDic{
    
    if (!_nameIndexDic) {
        _nameIndexDic = @{
                          @"黑龙江" : @"1",
                          @"吉林" : @"2",
                          @"辽宁" : @"3",
                          @"河北" : @"4",
                          @"山东" : @"5",
                          @"江苏" : @"6",
                          @"新疆" : @"29",
                          @"青海" : @"20",
                          @"西藏" : @"30",
                          @"四川" : @"18",
                          @"云南" : @"19",
                          @"广西" : @"28",
                          @"甘肃" : @"12",
                          @"宁夏" : @"26",
                          @"重庆" : @"23",
                          @"海南" : @"21",
                          @"广东" : @"31",
                          @"澳门" : @"34",
                          @"香港" : @"32",
                          @"台湾" : @"33",
                          @"福建" : @"15",
                          @"湖南" : @"16",
                          @"江西" : @"14",
                          @"浙江" : @"7",
                          @"上海" : @"22",
                          @"湖北" : @"13",
                          @"河南" : @"9",
                          @"山西" : @"10",
                          @"陕西" : @"11",
                          @"北京" : @"24",
                          @"天津" : @"25",
                          @"内蒙古" : @"27",
                          @"安徽" : @"8",
                          @"江苏" : @"6",
                          };
    }
    return _nameIndexDic;
}

- (NSDictionary *)indexNameDic{
    
    if (!_indexNameDic) {
        _indexNameDic = @{
                          @"1": @"黑龙江",
                          @"2" : @"吉林",
                          @"3" : @"辽宁",
                          @"4" : @"河北",
                          @"5" : @"山东",
                          @"6" : @"江苏",
                          @"29" : @"新疆",
                          @"20" : @"青海",
                          @"30" : @"西藏",
                          @"18" : @"四川",
                          @"19" : @"云南",
                          @"28" : @"广西",
                          @"12" : @"甘肃",
                          @"26" : @"宁夏",
                          @"23" : @"重庆",
                          @"21" : @"海南",
                          @"31" : @"广东",
                          @"34" : @"澳门",
                          @"32" : @"香港",
                          @"33" : @"台湾",
                          @"15" : @"福建",
                          @"16" : @"湖南",
                          @"14" : @"江西",
                          @"7" : @"浙江",
                          @"22" : @"上海",
                          @"13" : @"湖北",
                          @"9" : @"河南",
                          @"10" : @"山西",
                          @"11" : @"陕西",
                          @"24" : @"北京",
                          @"25" : @"天津",
                          @"27" : @"内蒙古",
                          @"8" : @"安徽",
                          @"6" : @"江苏",
                          };
    }
    return _indexNameDic;
}

@end
