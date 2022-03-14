//
//  SCGPUImageBaseFilter.h
//  SimpleCam
//
//  Created by maxslma on 2022/1/6.
//

#import "GPUImageFilter.h"

@interface SCGPUImageBaseFilter : GPUImageFilter

@property (nonatomic, assign) GLint timeUniform;
@property (nonatomic, assign) CGFloat time;

@property (nonatomic, assign) CGFloat beginTime;  // 滤镜开始应用的时间

@end
