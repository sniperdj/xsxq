//
//  SNPUploadModel.h
//  SNPNetwork
//
//  Created by Sniper on 2019/1/13.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SNPUploadModel : NSObject

/** 要上传的数据 */
@property (nonatomic, copy)NSData *data;
/** 上传的数据的名字 */
@property (nonatomic, copy)NSString *name;
/** 上传的文件名 */
@property (nonatomic, copy)NSString *fileName;
/** 类型 */
@property (nonatomic, copy)NSString *mimeType;

@end

NS_ASSUME_NONNULL_END
