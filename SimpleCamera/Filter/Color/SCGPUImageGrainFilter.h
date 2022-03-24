//
//  SCGPUImageGrainFilter.h
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageColorBaseFilter.h"

@interface SCGPUImageGrainFilter : SCGPUImageColorBaseFilter

@property (nonatomic, assign) CGFloat grain; //颗粒度调节，0.0f ~ 0.5f，其中0.0f表示原图。

@end
