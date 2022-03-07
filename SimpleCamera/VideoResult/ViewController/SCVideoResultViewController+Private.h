//
//  SCVideoResultViewController+Private.h
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "SCVideoResultViewController.h"
#import "SCAssetHelper.h"
#import "SCFileHelper.h"

@interface SCVideoResultViewController ()

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) CALayer *lastPlayerLayer; // 为了避免两段切换的时候出现短暂白屏

@property (nonatomic, strong) UIView *playerContainerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, assign) NSInteger currentVideoIndex;

#pragma mark - Action
- (void)confirmAction:(id)sender;
- (void)cancelAction:(id)sender;

#pragma mark - UI
- (void)setupUI;

@end
