//
//  SNPHTTPTask.m
//  SNPNetwork
//
//  Created by Sniper on 2019/1/6.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "SNPHTTPTask.h"
#import "AFNetworking.h"
#import "SNPHTTPRequest.h"
#import "SNPUploadModel.h"

@implementation SNPHTTPTask

+ (AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}

+ (NSURLSessionTask *)taskWithRequest:(SNPHTTPRequest *)request {
    [self customManagerWithRequest:request];
    if (request.reqMethod == SNPPost) {
        return [self makePostReq:request];
    } else if (request.reqMethod == SNPGet) {
        return [self makeGetReq:request];
    }
    return nil;
}

+ (AFHTTPSessionManager *)customManagerWithRequest:(SNPHTTPRequest *)req {
    AFHTTPSessionManager *manager = [self shareManager];
    NSDictionary *headers = req.headers;
    // 请求头
    for (NSString *headKey in headers) {
        id headObj = [headers objectForKey:headKey];
        [manager.requestSerializer setValue:headObj forHTTPHeaderField:headKey];
    }
    // 请求格式
    if (req.requestType == SNPRequestJSON) {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else if (req.requestType == SNPRequestHTTP) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    // 返回格式
    if (req.responseType == SNPResponseJSON) {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    } else if (req.responseType == SNPResponseHTTP) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return manager;
}
#pragma mark - 具体请求
+ (NSURLSessionTask *)makePostReq:(SNPHTTPRequest *)req {
    AFHTTPSessionManager *manager = [self customManagerWithRequest:req];
    [req willStartLoadWithUrl:req.url params:req.params];
    return [manager POST:req.url parameters:req.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [req didFinishLoadWithUrl:req.url urlTask:task];
        if (req.successBlock) {
            req.successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [req didFinishLoadWithUrl:req.url urlTask:task];
        if (req.failBlock) {
            req.failBlock(error);
        }
    }];
    
}

+ (NSURLSessionTask *)makeGetReq:(SNPHTTPRequest *)req {
    AFHTTPSessionManager *manager = [self customManagerWithRequest:req];
    return [manager GET:req.url parameters:req.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (req.successBlock) {
            req.successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (req.failBlock) {
            req.failBlock(error);
        }
    }];
}

+ (NSURLSessionTask *)makeUploadReq:(SNPHTTPRequest *)req {
    AFHTTPSessionManager *manager = [self customManagerWithRequest:req];
    return [manager POST:req.url parameters:req.params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (SNPUploadModel *file in req.uploadFiles) {
            [formData appendPartWithFileData:file.data name:file.name fileName:file.fileName mimeType:file.mimeType];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (req.progressBlock) {
            req.progressBlock(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (req.successBlock) {
            req.successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (req.failBlock) {
            req.failBlock(error);
        }
    }];
}

+ (NSURLSessionTask *)makeDownloadReq:(SNPHTTPRequest *)req {
    AFHTTPSessionManager *manager = [self customManagerWithRequest:req];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:req.url]];
    return [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (req.progressBlock) {
            req.progressBlock(downloadProgress);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        if (req.downloadFilePath != nil) {
            return [NSURL URLWithString:req.downloadFilePath];
        }
        NSURL *downloadUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [downloadUrl URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (req.failBlock) {
                req.failBlock(error);
            }
        } else {
            if (req.successBlock) {
                req.successBlock(filePath);
            }
        }
    }];
}

@end
