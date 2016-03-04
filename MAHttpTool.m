//
//  MAHttpTool.m
//
//  Created by MISSAJJ on 16/2/29.
//  Copyright © 2016年 MISSAJJ. All rights reserved.
//

/**
 *  @author https://github.com/MISSAJJ (MISSAJJ), 更新日期: 16-03-04 14:03:34
 *
 *  
 *
 */
#import "MAHttpTool.h"
#import "AFNetworking.h"
#import "MAUploadParam.h"

@implementation MAHttpTool

+ (void)requestURLString:(NSString *)URLString httpMethod:(NSString *)method parameters:(id)parameters success:(void(^)(id responseObject))success  failure:(void(^)(NSError *error))failure

{      //显示HUD
    [[MAHUDTool sharedMAHUDTool]showHUDInView:nil withString:GetLocalizedString(@"msg_loading", nil)];
    
    if ([InternetConnection isConnected])
   {
    
        //需要处理methodString的编码,防止崩溃
        method = [method stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
        
        
        if ([method isEqualToString:HTTPMETHOD_POST]) {
            
            /**
             *  POST请求
             */
            [manage POST:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSLog(@"response = %@",responseObject);
                
                // AFN请求成功的时候调用block，先把请求成功要做的事情，保存到这个代码块
                if(success){
                    success(responseObject);
                    //隐藏HUD
                    [[MAHUDTool sharedMAHUDTool]hideHUD];
                }
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
                NSLog(@"error = %@",error);
                
                if (failure) {
                    failure(error);
                    //错误处理
                    [self failureManageWithError:error];
                    //隐藏HUD
                    [[MAHUDTool sharedMAHUDTool]hideHUD];
                }
                
            }];
            
        }else{
            
            /**
             *  GET请求
             */
            [manage GET:URLString parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                
                NSLog(@"response GET= %@",responseObject);
                if(success){
                    success(responseObject);
                    //隐藏HUD
                    [[MAHUDTool sharedMAHUDTool]hideHUD];
                }
                
            } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                
                NSLog(@"error = %@",error);
                
                if (failure) {
                    failure(error);
                    //错误处理
                    [self failureManageWithError:error];
                    //隐藏HUD
                    [[MAHUDTool sharedMAHUDTool]hideHUD];
                }
                
            }];
        }
    }
   else{
    
        //错误处理
         [self displayAlertWithTitle:GetLocalizedString(@"appName", nil) andMessage:GetLocalizedString(@"msg_internet_connection_error", nil)];
        
        //隐藏HUD
        [[MAHUDTool sharedMAHUDTool]hideHUD];
    
    }

}
+ (void)uploadURLString:(NSString *)URLString parameters:(id)parameters uploadParam:(MAUploadParam *)uploadParam success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //显示HUD
    [[MAHUDTool sharedMAHUDTool]showHUDInView:nil withString:GetLocalizedString(@"msg_loading", nil)];
    
    if ([InternetConnection isConnected])
    {
        
        // 创建请求管理者
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        
        [mgr POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { // 上传的文件全部拼接到formData
            
            /**
             *  @author MISSAJJ, 16-02-29 15:02:52
             *
             *  FileData:要上传的文件的二进制数据
             *  name:上传参数名称
             *  fileName：上传到服务器的文件名称
             *  mimeType：文件类型
             
             //使用方法
             //1、创建上传的模型 (上传图片)
             MAUploadParam *uploadP = [[MAUploadParam alloc] init];
             uploadP.data = UIImagePNGRepresentation(image);
             uploadP.name = @"pic";
             uploadP.fileName = @"image.png";
             uploadP.mimeType = @"image/png";
             
             //2、请求HTTP：
             //（注意）如果一个方法，要传很多参数，就把参数先包装成一个模型,传参时再param.keyValues转成字典
             [MAHttpTool uploadURLString:URL_UPLOAD parameters:param.keyValues uploadParam:uploadP.mj success:^(id responseObject) {
             if (success) {
             success();
             }
             } failure:^(NSError *error) {
             if (failure) {
             failure(error);
             }
             }];
             */
            [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.fileName mimeType:uploadParam.mimeType];
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (success) {
                success(responseObject);
                
                //隐藏HUD
                [[MAHUDTool sharedMAHUDTool]hideHUD];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (failure) {
                failure(error);
                
                //错误处理
                [self failureManageWithError:error];
                //隐藏HUD
                [[MAHUDTool sharedMAHUDTool]hideHUD];
            }
        }];
        
    }
    else{
        
        //错误处理
        [self displayAlertWithTitle:GetLocalizedString(@"appName", nil) andMessage:GetLocalizedString(@"msg_internet_connection_error", nil)];
        
        //隐藏HUD
        [[MAHUDTool sharedMAHUDTool]hideHUD];
        
    }
    
}



/**
 *  错误处理: 根据返回的错误,alert提示不同的内容
 */
+(void)failureManageWithError: (NSError *)error{
    
    if ([[error description] rangeOfString:@"The request timed out."].location != NSNotFound)
    {
        [self displayAlertWithTitle:GetLocalizedString(@"appName", nil) andMessage:GetLocalizedString(@"requestTimeOut", nil)];
    }
    else if ([[error description] rangeOfString:@"The server can not find the requested page"].location != NSNotFound || [[error description] rangeOfString:@"A server with the specified hostname could not be found."].location != NSNotFound)
    {
        [self displayAlertWithTitle:GetLocalizedString(@"appName", nil) andMessage:GetLocalizedString(@"serverError", nil)];
    }
    else if([[error description] rangeOfString:@"The network connection was lost."].location != NSNotFound)
    {
        [self displayAlertWithTitle:GetLocalizedString(@"appName", nil) andMessage:GetLocalizedString(@"networkLost", nil)];
    }
    else
    {
        [self displayAlertWithTitle:GetLocalizedString(@"appName", nil) andMessage:GetLocalizedString(@"msg_internet_connection_error", nil)];
    }
    
}

//alert提示框
+(void)displayAlertWithTitle:(NSString *)title andMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:GetLocalizedString(@"ok", nil) otherButtonTitles:nil];
    [alert show];
}
@end
