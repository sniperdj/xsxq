//
//  PAVoiceLumeModel.h
//  PingAnBankVTM
//
//  Created by admin on 2018/12/25.
//  Copyright © 2018年 PingAnBankVTM. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PAVoiceLumeModel : NSObject

@property (nonatomic, assign) int value;
@property (nonatomic, assign) BOOL up;

- (instancetype)initValue:(double)value up:(BOOL)up;

@end

NS_ASSUME_NONNULL_END
