//
//  PAVoiceLumeModel.m
//  PingAnBankVTM
//
//  Created by admin on 2018/12/25.
//  Copyright © 2018年 PingAnBankVTM. All rights reserved.
//

#import "PAVoiceLumeModel.h"

@implementation PAVoiceLumeModel

- (instancetype)initValue:(double)value up:(BOOL)up
{
    self = [super init];
    if (self) {
        self.value = value;
        self.up = up;
    }
    return self;
}

@end
