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
    [SCCameraManager shareInstance].currentFilterHandler.beautifyFilterEnable = YES;
}

- (void)removeBeautifyFilter {
    [SCCameraManager shareInstance].currentFilterHandler.beautifyFilterEnable = NO;
}

- (NSArray<SCFilterMaterialModel *> *)filtersWithCategoryIndex:(NSInteger)index {
    if (index == 0) {
        return self.defaultFilterMaterials;
    } else if (index == 1) {
        return self.tikTokFilterMaterials;
    } else if (index == 2) {
        return self.splitFilterMaterials;
    } else if (index == 3) {
        return self.colorFilterMaterials;
    }
    return nil;
}

@end

#pragma clang diagnostic pop

