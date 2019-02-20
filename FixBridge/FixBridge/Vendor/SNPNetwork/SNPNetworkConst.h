//
//  SNPNetworkConst.h
//  SNPNetwork
//
//  Created by Sniper on 2019/1/6.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SNPHTTPMethod)
{
    SNPPost = 0,
    SNPGet
};

typedef NS_ENUM(NSInteger, SNPHTTPRequestType)
{
    SNPRequestJSON = 0,
    SNPRequestHTTP
};

typedef NS_ENUM(NSInteger, SNPHTTPResponseType)
{
    SNPResponseJSON = 0,
    SNPResponseHTTP
};

NS_ASSUME_NONNULL_BEGIN

@interface SNPNetworkConst : NSObject

@end

NS_ASSUME_NONNULL_END
