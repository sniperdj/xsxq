//
//  SNPHTTPData.h
//  SNPNetwork
//
//  Created by Sniper on 2019/1/7.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNPNetworkConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNPHTTPData : NSObject

- (NSString *)url;

- (NSDictionary *)headers;

- (NSDictionary *)params;

- (SNPHTTPMethod)reqMethod;

- (SNPHTTPRequestType)reqType;

- (SNPHTTPResponseType)resType;
///** 成功回调 */
//- (void (^)(id json))successBlock;
///** 失败回调 */
//- (void (^)(NSError *error))failBlock;

@end

NS_ASSUME_NONNULL_END
