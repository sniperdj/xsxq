//
//  PAVoiceAnimationView.m
//  PingAnBankVTM
//
//  Created by admin on 2018/12/25.
//  Copyright © 2018年 PingAnBankVTM. All rights reserved.
//

#import "PAVoiceAnimationView.h"
#import "PAVoiceLumeModel.h"

@interface PAVoiceAnimationView()

@property (nonatomic, strong) PAVoiceLumeModel *first;
@property (nonatomic, strong) PAVoiceLumeModel *second;
@property (nonatomic, strong) PAVoiceLumeModel *third;

@property (nonatomic, copy) NSString *start;

@end

@implementation PAVoiceAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.first = [[PAVoiceLumeModel alloc] initValue:(self.frame.size.height-6)*0.5 up:YES];
        self.second = [[PAVoiceLumeModel alloc] initValue:(self.frame.size.height-6) up:YES];
        self.third = [[PAVoiceLumeModel alloc] initValue:(self.frame.size.height-6)*0.3 up:YES];
    }
    return self;
}

- (void) animationIsStart:(BOOL)animation {
    if (animation) {
        self.start = @"开始";
        [self setNeedsDisplay];
    }else {
        self.start = nil;
    }
}

- (void)drawRect:(CGRect)rect
{
    if (self.start) {
        [self drawLine3];
    }
}

-(void)drawLine3{
    //贝瑟尔路径
    //1、创建路径
    CGFloat lineWidth = 5.0;
    CGFloat ridus = lineWidth * 0.5;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [[UIColor whiteColor] setStroke];
    [path setLineWidth:lineWidth];
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];
    
    [path moveToPoint:CGPointMake(ridus, self.frame.size.height-ridus)];
    [path addLineToPoint:CGPointMake(ridus, [self getCurrentValue:self.first])];
    
    [path moveToPoint:CGPointMake(self.frame.size.width*0.5, self.frame.size.height-ridus)];
    [path addLineToPoint:CGPointMake(self.frame.size.width*0.5, [self getCurrentValue:self.second])];
    
    [path moveToPoint:CGPointMake(self.frame.size.width-ridus, self.frame.size.height-ridus)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-ridus, [self getCurrentValue:self.third])];
    
    //3、渲染上下文到View的layer
    [path stroke];
    
    WEAKSELF
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf setNeedsDisplay];
    });
}

- (CGFloat)getCurrentValue:(PAVoiceLumeModel *)model {
    if (model.up) {
        model.value += 2;
        if (model.value >= (self.frame.size.height-6)) {
            model.value = (self.frame.size.height-6);
            model.up = NO;
        }
    }
    else {
        model.value -= 2;
        if (model.value <= 3) {
            model.value = 3;
            model.up = YES;
        }
    }
    return model.value;
}

@end
