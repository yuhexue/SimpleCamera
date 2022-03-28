//
//  MKCameraView.m
//  MagicCamera
//
//  Created by mkil on 2019/9/4.
//  Copyright © 2019 黎宁康. All rights reserved.
//

#import "MKCameraView.h"
#import "MKCameraFilterView.h"
#import "MKFilterModel.h"
#import "MKHeader.h"
#import <Masonry/Masonry.h>

@interface MKCameraView()

@property (nonatomic, strong) MKCameraFilterView *filterView;

@property (nonatomic, strong) UIButton *effectBt;
@property (nonatomic, strong) UIButton *filterStyleBt;
@property (nonatomic, strong) UIButton *beautifyBt;

@property (nonatomic, strong) NSArray<MKFilterModel *> *styleFilterModels;
@property (nonatomic, strong) NSArray<MKFilterModel *> *stickerFilterModels;

@end

@implementation MKCameraView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self generateDataSource];
    }
    
    return self;
}

- (void)setupUI
{
    weakSelf();
    
    _filterView = [[MKCameraFilterView alloc] initWithFrame:CGRectMake(0, kScreenH - 65 - 90 - 40, kScreenW, 90)];
    
    _filterView.selectFilterModelBlock = ^(MKFilterModel *model) {
        if (wself.delegate) {
            [wself.delegate alterFilterModel:model];
        }
    };
    
    _filterView.changeIntensityValueBlock = ^(float intensity) {
        if (wself.delegate) {
            [wself.delegate alterIntensity:intensity];
        }
    };
    
    _effectBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.effectBt setImage:[UIImage imageNamed:@"bt_camera_effect"] forState:UIControlStateNormal];
    [_effectBt addTarget:self action:@selector(onEffectBtClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _filterStyleBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.filterStyleBt setImage:[UIImage imageNamed:@"bt_camera_style_filter"] forState:UIControlStateNormal];
    [_filterStyleBt addTarget:self action:@selector(onFilterStyleBtClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _beautifyBt = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.beautifyBt setImage:[UIImage imageNamed:@"bt_camera_face_texiao_nor"] forState:UIControlStateNormal];
    [_beautifyBt addTarget:self action:@selector(onBeautifyBtClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_filterView];
    [self addSubview:_effectBt];
    [self addSubview:_filterStyleBt];
    [self addSubview:_beautifyBt];
    
    [self.effectBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.left.equalTo(self.mas_left).offset(36);
        make.top.equalTo(self.mas_top).offset(100);
    }];

    [self.filterStyleBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.right.equalTo(self.beautifyBt.mas_left).offset(-36);
        make.bottom.equalTo(self.mas_bottom).offset(-165);
    }];

    [self.beautifyBt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(34, 34));
        make.right.equalTo(self.mas_right).offset(-36);
        make.bottom.equalTo(self.mas_bottom).offset(-65);
    }];
}


- (void)onEffectBtClick:(UIButton *)bt {
    _filterView.filterModels = _stickerFilterModels;
    [_filterView toggle];
}

- (void)onFilterStyleBtClick:(UIButton *)bt {
    _filterView.filterModels = _styleFilterModels;
    [_filterView toggle];
}

- (void)onBeautifyBtClick:(UIButton *)bt {
    

}

#pragma mark - PublicMethod

- (void)generateDataSource
{
    _styleFilterModels = [MKFilterModel buildFilterModelsWithPath:kStyleFilterPath whitType:MKFilterTypeStyle];
    _stickerFilterModels = [MKFilterModel buildFilterModelsWithPath:kStickerFilterPath whitType:MKFilterTypeEffects];
}

@end
