//
//  SCCameraViewController+UI.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCCameraViewController+UI.h"
#import "SCCameraViewController+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation SCCameraViewController (UI)

- (void)setupCameraView {
    self.cameraView = [[GPUImageView alloc] init];
    [self.view addSubview:self.cameraView];
    [self.cameraView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.mas_height);
    }];
}

- (void)setupCapturingButton {
    self.capturingButton = [[SCCapturingButton alloc] init];
    self.capturingButton.delegate = self;
    
    [self.view addSubview:self.capturingButton];
    [self.capturingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.centerX.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-40);
        } else {
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-40);
        }
    }];
}

@end

#pragma clang diagnostic pop
