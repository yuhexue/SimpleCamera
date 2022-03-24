//
//  SCGPUImageTemperatureFilter.h
//  SimpleCam
//
//  Created by maxslma on 2022/3/20.
//

#import "SCGPUImageColorBaseFilter.h"

/**
 色调涉及到RGB和YIQ的转换，就是两种色彩系统的转换，
 调整色温的temperature范围是2000.0f ~ 8000.0f，5000.0f表示原图，
 另一个参数tint默认是0.0f。
 */
@interface SCGPUImageTemperatureFilter : SCGPUImageColorBaseFilter

@property (nonatomic, assign) CGFloat temperature;
@property (nonatomic, assign) CGFloat tint;

@end
