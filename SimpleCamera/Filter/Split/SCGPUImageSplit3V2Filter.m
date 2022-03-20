//
//  SCGPUImageSplit3V2Filter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/16.

#import "SCGPUImageSplit3V2Filter.h"

@implementation SCGPUImageSplit3V2Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 3.0;
        self.vertical = 2.0;
    }
    return self;
}

@end
