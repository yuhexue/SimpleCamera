//
//  SCCameraViewController+Filter.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCCameraViewController+Filter.h"
#import "SCCameraViewController+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (Filter)

- (void)setupFilters {
    self.currentFilters = [[GPUImageFilter alloc] init];
}

@end

#pragma clang diagnostic pop

