//
//  SCGPUImageSplit1V3Filter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/16.

#import "SCGPUImageSplit1V3Filter.h"

@implementation SCGPUImageSplit1V3Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 1.0;
        self.vertical = 3.0;
    }
    return self;
}

@end
