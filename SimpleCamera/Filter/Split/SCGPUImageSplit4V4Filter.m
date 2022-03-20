//
//  SCGPUImageSplit4V4Filter.m
//  SimpleCam
//
//  Created by maxslma on 2022/3/16.

#import "SCGPUImageSplit4V4Filter.h"

@implementation SCGPUImageSplit4V4Filter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.horizontal = 4.0;
        self.vertical = 4.0;
    }
    return self;
}

@end
