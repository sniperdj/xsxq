//
//  XSVoiceRecManager.h
//  XSDemo
//
//  Created by admin on 2019/2/1.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XSVoiceRecManager : NSObject

+ (instancetype)shareVoiceRec;

- (void)startRecWithResultBlock:(void(^)(NSString *recString))resultBlock;

- (void)stopRec;

- (void)releaseRecResource;

@end

NS_ASSUME_NONNULL_END
