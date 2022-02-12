//
//  SCFileHelper.h
//  SimpleCamera
//
//  Created by maxslma on 2022/2/11.
//

#import <Foundation/Foundation.h>

 @interface SCFileHelper : NSObject

 /**
  tmp 文件夹
  */
 + (NSString *)temporaryDirectory;

 /**
  通过文件名返回 tmp 文件夹中的文件路径
  */
 + (NSString *)filePathInTmpWithName:(NSString *)name;

 /**
  返回 tmp 文件夹中的一个随机路径
  */
+ (NSString *)randomFilePathInTmpWithSuffix:(NSString *)suffix;

 @end
