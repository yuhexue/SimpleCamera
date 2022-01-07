//
//  SCCameraViewController+TakePhoto.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCCameraViewController+TakePhoto.h"
#import "SCCameraViewController+Private.h"
#import "SCPhotoResultViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (TakePhoto)

- (void)takePhoto {
    @weakify(self);
    [[SCCameraManager shareInstance] takePhotoWithFilters:nil completion:^(UIImage *resultImage, NSError *error) {
        @strongify(self);
        SCPhotoResultViewController *resultVC = [[SCPhotoResultViewController alloc] init];
        resultVC.resultImage = resultImage;
        [self.navigationController pushViewController:resultVC animated:NO];
    }];
}

@end

#pragma clang diagnostic pop
