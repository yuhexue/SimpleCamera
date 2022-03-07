//
//  SCCapturingButton.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCCapturingButton.h"
#import "UIView+Extention.h"

@interface SCCapturingButton ()

@property (nonatomic, strong) UIView *recordStopView;  // 录制视频暂停控件

@end

@implementation SCCapturingButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

#pragma mark - Private

- (void)commonInit {
    self.capturingState = SCCapturingButtonStateNormal;
    [self setImage:[UIImage imageNamed:@"btn_capture"] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    [self setupRecordStopView];
}

- (void)setupRecordStopView {
    self.recordStopView = [[UIView alloc] init];
    self.recordStopView.userInteractionEnabled = NO;
    self.recordStopView.alpha = 0;
    self.recordStopView.layer.cornerRadius = 5;
    self.recordStopView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.recordStopView];
    [self.recordStopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
 }

#pragma mark - Actions

- (void)touchUpInsideAction:(UIButton *)button {
    if (self.delegate && [self.delegate respondsToSelector:@selector(capturingButtonDidClicked:)]) {
        [self.delegate capturingButtonDidClicked:self];
    }
}

#pragma mark - Custom Accessor

- (void)setCapturingState:(SCCapturingButtonState)capturingState {
    _capturingState = capturingState;

    [self.recordStopView setHidden:(capturingState == SCCapturingButtonStateNormal)
                          animated:YES
                        completion:NULL];
}


@end
