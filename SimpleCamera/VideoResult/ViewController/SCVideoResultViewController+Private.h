//
//  SCVideoResultViewController+Private.h
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "SCVideoResultViewController.h"

@interface SCVideoResultViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

#pragma mark - Action
- (void)confirmAction:(id)sender;
- (void)cancelAction:(id)sender;

#pragma mark - UI
- (void)setupUI;

@end
