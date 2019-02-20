//
//  SNPHTTPRequest.h
//  SNPNetwork
//
//  Created by Sniper on 2019/1/6.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNPNetworkConst.h"
@class SNPUploadModel;

NS_ASSUME_NONNULL_BEGIN

@interface SNPHTTPRequest : NSObject

/** 请求url */
@property (nonatomic, copy)NSString *url;
/** 请求头 */
@property (nonatomic, strong)NSDictionary *headers;
/** 请求体 */
@property (nonatomic, strong)NSDictionary *params;
/** 上传的文件数组 */
@property (nonatomic, strong)NSMutableArray<SNPUploadModel *> *uploadFiles;
/** 下载路径 */
@property (nonatomic, copy)NSString *downloadFilePath;
/** httpMethod */
@property (nonatomic, assign)SNPHTTPMethod reqMethod;
/** 请求格式 */
@property (nonatomic, assign)SNPHTTPRequestType requestType;
/** 返回格式 */
@property (nonatomic, assign)SNPHTTPResponseType responseType;
/** 成功回调 */
@property (nonatomic, copy)void (^successBlock)(id json);
/** 失败回调 */
@property (nonatomic, copy)void (^failBlock)(NSError *error);
/** 进度回调 */
@property (nonatomic, copy)void (^progressBlock)(NSProgress *progress);

- (void)willStartLoadWithUrl:(NSString *)url params:(NSDictionary *)params;

- (void)didFinishLoadWithUrl:(NSString *)url urlTask:(NSURLSessionDataTask *)task;

@end

NS_ASSUME_NONNULL_END
