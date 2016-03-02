//
//  MAHttpTool.h
//  shtrip
//
//  Created by MISSAJJ on 16/2/29.
//  Copyright © 2016年 MISSAJJ. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MAUploadParam;
@interface MAHttpTool : NSObject

/**
 *  @author MISSAJJ, 更新日期: 16-03-02 14:03:54
 *
 *   请求api  *****返回block***** 分为 post 和get 两种 请求方式
 *
 *  @param URLString  请求的基本url
 *  @param method     请求方法（get，post）
 *  @param parameters 请求的参数字典
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
+ (void)requestURLString:(NSString *)URLString
     httpMethod:(NSString *)method
     parameters:(id)parameters
        success:(void (^)(id responseObject))success
        failure:(void (^)(NSError *error))failure;

/**
 *  @author MISSAJJ, 16-03-02 14:03:54
 *
 *  上传图片或者文件的请求
 *
 *  @param URLString   请求的基本的url
 *  @param parameters  请求的参数字典
 *  @param uploadParam 上传的参数字典
 *  @param success     请求成功的回调
 *  @param failure     请求失败的回调
 *
 */
+ (void)uploadURLString:(NSString *)URLString
    parameters:(id)parameters
   uploadParam:(MAUploadParam *)uploadParam
       success:(void (^)(id responseObject))success
       failure:(void (^)(NSError *error))failure;
@end
