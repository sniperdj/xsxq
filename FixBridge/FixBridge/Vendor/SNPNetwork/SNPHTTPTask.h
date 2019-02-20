//
//  SNPHTTPTask.h
//  SNPNetwork
//
//  Created by Sniper on 2019/1/6.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SNPHTTPRequest;

NS_ASSUME_NONNULL_BEGIN

@interface SNPHTTPTask : NSObject

+ (NSURLSessionTask *)taskWithRequest:(SNPHTTPRequest *)request;

@end

NS_ASSUME_NONNULL_END
