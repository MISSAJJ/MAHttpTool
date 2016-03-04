

### MAHttpTool 

`MISSAJJ`自己写的一个基于`AFNetworking`为内核的HTTP请求工具类 



###更新日期

更新日期: 16-03-04 14:03:34

1,增加HUD功能 [MAHUDTool](https://github.com/MISSAJJ/MAHUDTool) ,

此工具类是将HUD提示框单独抽出一个单例工具类, 目前使用的是MBProgressHUD,后期如果项目需要换SVProgressHUD,JGProgressHUD等其他HUD,只需要在[MAHUDTool](https://github.com/MISSAJJ/MAHUDTool) 这个类里单独改写

2,通过alert,处理返回的网络错误


更新日期: 16-02-29 14:02:17

提供参数httpMethod:(NSString *)method, 判断是 GET 还是 POST 请求



###前言

短短一年,为目前的公司陆续开发了5个独立的APP项目了(其中4个APP已经上架了AppStore),

由于经手的项目逐渐增多,更新维护周期频繁,常常无暇去总结归纳或者重构代码,

面对早期只是为了实现功能及效果而写的冗余代码,总是心有余力不足,

在心头积压了很多无奈,遗憾,纠结.....


2016年新年过后,乘着完成上架第5个APP项目后的空闲,陆续整理一些自己项目中积累下来的工具类,

这些工具类基于[MJ大咖](https://github.com/CoderMJLee) 的项目分层逻辑思维的灵魂,融合了自己的项目实践,

对于一些IOS开发新手来说,还是很容易理解,也有些帮助的...


###Why?为什么要写这个工具类？

  用代码分层的理念和方案，单独写了一个`MAHttpTool`工具类用于调用`AFNetworking`请求服务器端的API数据，后期如果项目需要修改就只需要在这个MAHttpTool工具类里改写和调试，不用在整个项目里批量寻找再一段一段改写代码了，提高了效率。
  
 提供参数httpMethod:(NSString *)method, 判断是 GET 还是 POST 请求
  


###Void＃请求方法################################################

```objective-c

/**
 *  @author MISSAJJ, 16-02-29 14:02:17
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
        success:(void (^)(id))success
        failure:(void (^)(NSError *))failure;
 
```
###Practice # 使用实践################################################
```objective-c

#pragma mark ==请求api获取用户数据==
- (void)getUserInfoWithParameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure
{

    //请求API
    [MAHttpTool requestURLString:LOGIN httpMethod:HTTPMETHOD_POST parameters:parameters success:^(id responseObject) {
        
        if(success){
            success(responseObject);  //继续通过block回传给上层去处理数据
        }
        
    } failure:^(NSError *error) {
       
        if (failure) {
            failure(error);
        }
        
   }];
    
}

```

###Void＃上传图片或者文件的请求方法################################################
```objective-c
/**
 *  @author MISSAJJ, 16-02-29 15:02:00
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


```
此方法是借鉴了[MJ大咖](https://github.com/CoderMJLee) 的视频课程,将上传的参数字典建立模型

###Practice # 上传图片或者文件的使用实践################################################
```objective-c
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
         [MAHttpTool uploadURLString:URL_UPLOAD parameters:param.keyValues uploadParam:uploadP success:^(id responseObject) {
         if (success) {
         success();
         }
         } failure:^(NSError *error) {
         if (failure) {
         failure(error);
         }
         }];

```


###Other其他
 

很希望能和大咖们一起快乐地奔跑,不再是一个孤独的攻城狮，
希望能有更多的狮子一起共勉探讨学习，共同进步！

我的联系方式 ： QQ   996174446  ［验证：IOS攻城狮］
