//
//  SNPHTTPManager.m
//  SNPNetwork
//
//  Created by Sniper on 2019/1/6.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "SNPHTTPManager.h"
#import "SNPHTTPRequest.h"
#import "SNPHTTPTask.h"
#import "SNPHTTPData.h"

@interface SNPHTTPManager ()

/** 请求对象 */
@property (nonatomic, strong)SNPHTTPRequest *request;

@end

@implementation SNPHTTPManager

//SNPHTTPManager *reqManager(SNPHTTPMethod method) {
//    SNPHTTPManager *manager = [SNPHTTPManager new];
//    manager.request = [[SNPHTTPRequest alloc] init];
//    manager.request.reqMethod = method;
//    manager.request.requestType = SNPRequestJSON;
//    manager.request.responseType = SNPResponseJSON;
//    return manager;
//}
//
SNPHTTPManager *reqData(SNPHTTPData *data) {
    SNPHTTPManager *manager = [SNPHTTPManager new];
    manager.request = [[SNPHTTPRequest alloc] init];
    manager.reqUrl([data url]).reqMethod([data reqMethod]).reqHeaders([data headers]).reqParams([data params]).reqType([data reqType]).resType([data resType]);
    return manager;
}

+ (SNPHTTPManager *)reqManager {
    SNPHTTPManager *manager = [[SNPHTTPManager alloc] init];
    manager.request.reqMethod = SNPPost;
    manager.request.requestType = SNPRequestJSON;
    manager.request.responseType = SNPResponseJSON;
    return manager;
}

+ (SNPHTTPManager *)reqManagerWithData:(SNPHTTPData *)data {
    SNPHTTPManager *manager = [[SNPHTTPManager alloc] init];
    manager.reqUrl([data url]).reqMethod([data reqMethod]).reqHeaders([data headers]).reqParams([data params]).reqType([data reqType]).resType([data resType]);
    return manager;
}

#pragma mark - link property
- (SNPHTTPManager *(^)(NSString *url))reqUrl {
    return ^(NSString *url) {
        self.request.url = url;
        return self;
    };
}

- (SNPHTTPManager *(^)(NSDictionary *headers))reqHeaders {
    return ^(NSDictionary *headers) {
        if (headers != nil) {
            self.request.headers = headers;
        }
        return self;
    };
}

- (SNPHTTPManager *(^)(NSDictionary *params))reqParams {
    return ^(NSDictionary *params) {
        if (params != nil) {
            self.request.params = params;
        }
        return self;
    };
}

- (SNPHTTPManager * _Nonnull (^)(SNPHTTPMethod))reqMethod {
    return ^(SNPHTTPMethod method) {
        self.request.reqMethod = method;
        return self;
    };
}

- (SNPHTTPManager *(^)(SNPHTTPRequestType))reqType {
    return ^(SNPHTTPRequestType type) {
        self.request.requestType = type;
        return self;
    };
}

- (SNPHTTPManager *(^)(SNPHTTPResponseType))resType {
    return ^(SNPHTTPResponseType type) {
        self.request.responseType = type;
        return self;
    };
}

- (SNPHTTPManager * _Nonnull (^)(void (^ _Nonnull)(id _Nonnull), void (^ _Nonnull)(NSError * _Nonnull)))reqResult {
    return ^(void (^succBlock)(id _Nonnull), void (^failBlock)(NSError * _Nonnull)) {
        self.request.successBlock = succBlock;
        self.request.failBlock = failBlock;
        [SNPHTTPTask taskWithRequest:self.request];
        return self;
    };
}

- (SNPHTTPRequest *)request {
    if (!_request) {
        _request = [[SNPHTTPRequest alloc] init];
    }
    return _request;
}

@end
