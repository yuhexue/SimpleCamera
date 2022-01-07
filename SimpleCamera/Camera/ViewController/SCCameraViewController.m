//
//  SCCameraViewController.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCCameraViewController.h"
#import "SCCameraViewController+Private.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"

@implementation SCCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
    
    SCCameraManager *cameraManager = [SCCameraManager shareInstance];
    [cameraManager addOutputView:self.cameraView];
    [cameraManager setCameraFilters:self.currentFilters];
    [cameraManager startCapturing];
}

#pragma mark - Public

#pragma mark - Private

- (void)commonInit {
    [self setupCameraView];
    [self setupCapturingButton];
}

#pragma mark - SCCapturingButtonDelegate

- (void)capturingButtonDidClicked:(SCCapturingButton *)button {
    [self takePhoto];
}

@end

#pragma clang diagnostic pop
