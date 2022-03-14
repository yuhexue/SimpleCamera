//
//  SCFilterHandler.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <GPUImage.h>
#import <Foundation/Foundation.h>

@interface SCFilterHandler : NSObject

// 滤镜链源头
@property (nonatomic, weak) GPUImageOutput *source;

- (GPUImageFilter *)firstFilter;
- (GPUImageFilter *)lastFilter;

/// 往末尾添加一个滤镜
- (void)addFilter:(GPUImageFilter *)filter;

/// 设置美颜滤镜
- (void)setBeautifyFilter:(GPUImageFilter *)filter;

/// 设置效果滤镜
- (void)setEffectFilter:(GPUImageFilter *)filter;

@end
