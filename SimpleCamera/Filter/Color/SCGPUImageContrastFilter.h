//
//  SCGPUImageContrastFilter.h
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

//对比度
#import "SCGPUImageColorBaseFilter.h"

@interface SCGPUImageContrastFilter : SCGPUImageColorBaseFilter

@property (nonatomic, assign) CGFloat contrast; //对比度调节，0.0f ~ 2.0f，其中1.0f表示原图。

@end
