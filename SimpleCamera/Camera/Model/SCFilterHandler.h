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
@property (nonatomic, assign) BOOL beautifyFilterEnable;
@property (nonatomic, assign) CGFloat beautifyFilterRatio; /// 美颜滤镜的程度，0～1，默认 0.5
@property (nonatomic, assign) CGFloat colorFilterRatio; /// 颜色滤镜的程度，0～1，默认 0.5
/// 人脸点
@property (nonatomic, assign) GLfloat *facesPoints;
- (GPUImageFilter *)firstFilter;
- (GPUImageFilter *)lastFilter;

/// 往末尾添加一个滤镜
- (void)addFilter:(GPUImageFilter *)filter;

/// 设置效果滤镜
- (void)setEffectFilter:(GPUImageFilter *)filter;

@end
