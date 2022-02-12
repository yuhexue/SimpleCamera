//
//  SCCapturingModeSwitchView.m
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import "SCCapturingModeSwitchView.h"

@interface SCCapturingModeSwitchView ()

@property (nonatomic, assign, readwrite) SCCapturingModeSwitchType type;

@property (nonatomic, strong) UILabel *imageLabel;
@property (nonatomic, strong) UILabel *videoLabel;

@end

@implementation SCCapturingModeSwitchView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Private

- (void)commonInit {
    [self setupImageLabel];
    [self setupVideoLabel];
}

- (void)setupImageLabel {
    self.imageLabel = [[UILabel alloc] init];
    self.imageLabel.text = @"拍照";
    self.imageLabel.textAlignment = NSTextAlignmentCenter;
    self.imageLabel.userInteractionEnabled = YES;
    self.imageLabel.textColor = [UIColor whiteColor];
    self.imageLabel.font = [UIFont boldSystemFontOfSize:12];
    [self addSubview:self.imageLabel];
    [self.imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];

    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAciton)];
    [self.imageLabel addGestureRecognizer:imageTap];
}

- (void)setupVideoLabel {
    self.videoLabel = [[UILabel alloc] init];
    self.videoLabel.text = @"录制";
    self.videoLabel.textAlignment = NSTextAlignmentCenter;
    self.videoLabel.userInteractionEnabled = YES;
    self.videoLabel.textColor = RGBA(255, 255, 255, 0.6);
    self.videoLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.videoLabel];
    [self.videoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];

    UITapGestureRecognizer *videoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoTapAction)];
    [self.videoLabel addGestureRecognizer:videoTap];
}

- (void)selectType:(SCCapturingModeSwitchType)type {
    if (self.type == type) {
        return;
    }
    self.type = type;
    UILabel *selectedLabel = nil;
    UILabel *normalLabel = nil;
    if (self.type == SCCapturingModeSwitchTypeImage) {
        selectedLabel = self.imageLabel;
        normalLabel = self.videoLabel;
    } else {
        selectedLabel = self.videoLabel;
        normalLabel = self.imageLabel;
    }
    selectedLabel.textColor =  [UIColor whiteColor];
    selectedLabel.font = [UIFont boldSystemFontOfSize:12];
    normalLabel.textColor = RGBA(255, 255, 255, 0.6);
    normalLabel.font = [UIFont systemFontOfSize:12];

    [self. delegate capturingModeSwitchView:self didChangeToType:self.type];
}

#pragma mark - Action

- (void)imageTapAciton {
    [self selectType:SCCapturingModeSwitchTypeImage];
}

- (void)videoTapAction {
    [self selectType:SCCapturingModeSwitchTypeVideo];
}

@end
