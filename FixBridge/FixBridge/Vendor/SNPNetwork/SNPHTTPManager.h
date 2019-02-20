//
//  SNPHTTPManager.h
//  SNPNetwork
//
//  Created by Sniper on 2019/1/6.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNPNetworkConst.h"
@class SNPHTTPData;

NS_ASSUME_NONNULL_BEGIN

@interface SNPHTTPManager : NSObject

//SNPHTTPManager *reqManager(SNPHTTPMethod method);
//
SNPHTTPManager *reqData(SNPHTTPData *data);

+ (SNPHTTPManager *)reqManager;

- (SNPHTTPManager *(^)(NSString *url))reqUrl;

- (SNPHTTPManager *(^)(NSDictionary *headers))reqHeaders;

- (SNPHTTPManager *(^)(NSDictionary *params))reqParams;

- (SNPHTTPManager *(^)(SNPHTTPMethod method))reqMethod;

- (SNPHTTPManager *(^)(SNPHTTPRequestType))reqType;

- (SNPHTTPManager *(^)(SNPHTTPResponseType))resType;

- (SNPHTTPManager * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull), void (^ _Nonnull)(NSError * _Nonnull)))reqResult;

@end

NS_ASSUME_NONNULL_END
