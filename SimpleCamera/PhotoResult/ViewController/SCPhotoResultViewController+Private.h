//
//  SCPhotoResultViewController+Private.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/7.
//

#import "SCPhotoResultViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCPhotoResultViewController ()

@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

#pragma mark - Action

- (void)confirmAction:(id)sender;
- (void)cancelAction:(id)sender;

#pragma mark - UI

- (void)setupUI;

@end

NS_ASSUME_NONNULL_END
