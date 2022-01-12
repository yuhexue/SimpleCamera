//
//  SCFilterHelper.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCFilterHelper.h"

@implementation SCFilterHelper

+ (UIImage *)imageWithFilter:(GPUImageFilter *)filter originImage:(UIImage *)originImage {
    [filter forceProcessingAtSize:originImage.size];
    GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:originImage];
    [picture addTarget:filter];
    
    [picture processImage];
    [filter useNextFrameForImageCapture];
    
    return [filter imageFromCurrentFramebuffer];
}


@end
