//
//  SCGPUImageSaturationFilter.h
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageBaseFilter.h"

@interface SCGPUImageSaturationFilter : SCGPUImageBaseFilter

@property (nonatomic, assign) CGFloat saturation; //饱和度调节，0.0f ~ 2.0f，其中1.0f表示原图。

@end
