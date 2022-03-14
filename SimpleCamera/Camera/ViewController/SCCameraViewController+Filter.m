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

- (void)addBeautifyFilter {
    GPUImageFilter *beautifyFilter = (GPUImageFilter *)[[GPUImageBeautifyFilter alloc] init];
    [[SCCameraManager shareInstance].currentFilterHandler setBeautifyFilter:beautifyFilter];
}

- (void)removeBeautifyFilter {
    [[SCCameraManager shareInstance].currentFilterHandler setBeautifyFilter:nil];
}

- (NSArray<SCFilterMaterialModel *> *)filtersWithCategoryIndex:(NSInteger)index {
    if (index == 0) {
        return self.defaultFilterMaterials;
    } else if (index == 1) {
        return self.tikTokFilterMaterials;
    }
    return nil;
}

@end

#pragma clang diagnostic pop

