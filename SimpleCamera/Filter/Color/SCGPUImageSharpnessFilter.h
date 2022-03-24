//
//  SCGPUImageSharpnessFilter.h
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageColorBaseFilter.h"

@interface SCGPUImageSharpnessFilter : SCGPUImageColorBaseFilter

@property (nonatomic, assign) CGFloat sharpness; //锐度调节，-4.0f ~ 4.0f，其中0.0f表示原图。

@end
