//
//  SCGPUImageStaticSplitFilter.h
//  SimpleCam
//
//  Created by maxslma on 2022/3/16.
//

#import "SCGPUImageBaseFilter.h"

@interface SCGPUImageStaticSplitFilter : SCGPUImageBaseFilter

/// 水平分割数，默认 2.0，最小 1.0
@property (nonatomic, assign) CGFloat horizontal;
/// 竖直分割数，默认 2.0，最小 1.0
@property (nonatomic, assign) CGFloat vertical;

@end
