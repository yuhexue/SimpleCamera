//
//  SCViewController.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCViewController.h"

@interface SCViewController ()

@end

@implementation SCViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
