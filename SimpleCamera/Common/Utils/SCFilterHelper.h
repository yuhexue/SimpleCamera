//
//  SCFilterHelper.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import <GPUImage.h>
#import <Foundation/Foundation.h>

@interface SCFilterHelper : NSObject

/**
 给图片上滤镜效果

 @param filter 滤镜
 @param originImage 原图
 @return 效果图
 */
+ (UIImage *)imageWithFilter:(GPUImageFilter *)filter originImage:(UIImage *)originImage;

@end
