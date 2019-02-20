//
//  SNPHTTPData.m
//  SNPNetwork
//
//  Created by Sniper on 2019/1/7.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "SNPHTTPData.h"

@implementation SNPHTTPData

- (NSString *)url {
    return nil;
}

- (NSDictionary *)headers {
    return nil;
}

- (NSDictionary *)params {
    return nil;
}

- (SNPHTTPMethod)reqMethod {
    return SNPPost;
}

- (SNPHTTPRequestType)reqType {
    return SNPRequestJSON;
}

- (SNPHTTPResponseType)resType {
    return SNPResponseJSON;
}

@end
