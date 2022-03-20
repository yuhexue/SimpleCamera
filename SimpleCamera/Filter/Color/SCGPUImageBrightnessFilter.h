//
//  SCGPUImageBrightnessFilter.h
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageBaseFilter.h"

@interface SCGPUImageBrightnessFilter : SCGPUImageBaseFilter

@property (nonatomic, assign) CGFloat brightness; //亮度调节，-1.0f ~ 1.0f，其中0.0f表示原图。

@end
