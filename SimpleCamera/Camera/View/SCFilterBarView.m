//
//  SCFilterBarView.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCFilterBarView.h"
#import "SCFilterCategoryView.h"

#import "SCFilterMaterialView.h"

static CGFloat const kFilterMaterialViewHeight = 100.0f;
static CGFloat const kSliderOrginValue = 0.5f;

@interface SCFilterBarView () <SCFilterMaterialViewDelegate, SCFilterCategoryViewDelegate>

@property (nonatomic, strong) SCFilterMaterialView *filterMaterialView;
@property (nonatomic, strong) SCFilterCategoryView *filterCategoryView;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UILabel *switchLabel;
@property (nonatomic, strong) UISlider *sliderView;

@property (nonatomic, assign) SCFilterBarViewFilterType sliderType;

@end

@implementation SCFilterBarView

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

#pragma mark - Private

- (void)commonInit {
    self.backgroundColor = RGBA(0, 0, 0, 0.5);
    
    [self setupFilterCategoryView];
    [self setupFilterMaterialView];
    [self setupSwitchView];
    [self setupSliderView];
}

- (void)setupFilterCategoryView {
    self.filterCategoryView = [[SCFilterCategoryView alloc] init];
    self.filterCategoryView.delegate = self;
    self.filterCategoryView.itemNormalColor = [UIColor whiteColor];
    self.filterCategoryView.itemSelectColor = ThemeColor;
    self.filterCategoryView.itemList = @[@"内置", @"抖音", @"分屏", @"颜色"];
    self.filterCategoryView.itemFont = [UIFont systemFontOfSize:14];
    self.filterCategoryView.itemWidth = 65;
    self.filterCategoryView.bottomLineWidth = 30;
    [self addSubview:self.filterCategoryView];
    [self.filterCategoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self);
        make.height.mas_equalTo(35);
    }];
}

- (void)setupFilterMaterialView {
    self.filterMaterialView = [[SCFilterMaterialView alloc] init];
    self.filterMaterialView.delegate = self;
    [self addSubview:self.filterMaterialView];
    [self.filterMaterialView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(50);
        make.height.mas_equalTo(kFilterMaterialViewHeight);
    }];
}

- (void)setupSwitchView {
    self.switchView = [[UISwitch alloc] init];
    self.switchView.onTintColor = ThemeColor;
    self.switchView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [self.switchView addTarget:self
                        action:@selector(switchValueChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.top.equalTo(self.filterMaterialView.mas_bottom).offset(8);
    }];
    
    self.switchLabel = [[UILabel alloc] init];
    self.switchLabel.textColor = [UIColor whiteColor];
    self.switchLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.switchLabel];
    [self.switchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.switchView.mas_right).offset(3);
        make.centerY.equalTo(self.switchView);
    }];
}

- (void)setupSliderView {
    self.sliderView = [[UISlider alloc] init];
    self.sliderView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    self.sliderView.minimumTrackTintColor = [UIColor whiteColor];
    self.sliderView.maximumTrackTintColor = RGBA(255, 255, 255, 0.6);
    self.sliderView.value = kSliderOrginValue;
    self.sliderView.alpha = 1;
    [self.sliderView addTarget:self
                        action:@selector(sliderValueChanged:)
                forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.sliderView];
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.switchView.mas_right).offset(30);
        make.centerY.equalTo(self.switchView);
        make.right.equalTo(self).offset(-10);
    }];
}
#pragma mark - Public

- (NSInteger)currentCategoryIndex {
    return self.filterCategoryView.currentIndex;
}

#pragma mark - Action

- (void)switchValueChanged:(id)sender {
    self.sliderView.hidden = !self.switchView.isOn;
    [self.delegate filterBarView:self enableBeautify:self.switchView.isOn];
}

- (void)sliderValueChanged:(id)sender {
    [self.delegate filterBarView:self type:self.sliderType sliderChangeToValue:self.sliderView.value];
}

#pragma mark - Custom Accessor

- (void)setDefaultFilterMaterials:(NSArray<SCFilterMaterialModel *> *)defaultFilterMaterials {
    _defaultFilterMaterials = [defaultFilterMaterials copy];
    
    if (self.filterCategoryView.currentIndex == 0) {
        self.filterMaterialView.itemList = defaultFilterMaterials;
    }
}

- (void)setTikTokFilterMaterials:(NSArray<SCFilterMaterialModel *> *)tikTokFilterMaterials {
    _tikTokFilterMaterials = [tikTokFilterMaterials copy];
    
    if (self.filterCategoryView.currentIndex == 1) {
        self.filterMaterialView.itemList = tikTokFilterMaterials;
    }
}

- (void)setSplitFilterMaterials:(NSArray<SCFilterMaterialModel *> *)splitFilterMaterials {
    _splitFilterMaterials = [splitFilterMaterials copy];

    if (self.filterCategoryView.currentIndex == 2) {
        self.filterMaterialView.itemList = splitFilterMaterials;
    }
}

- (void)setColorFilterMaterials:(NSArray<SCFilterMaterialModel *> *)colorFilterMaterials {
    _colorFilterMaterials = [colorFilterMaterials copy];

    if (self.filterCategoryView.currentIndex == 3) {
        self.filterMaterialView.itemList = colorFilterMaterials;
    }
}

#pragma mark - SCFilterMaterialViewDelegate

- (void)filterMaterialView:(SCFilterMaterialView *)filterMaterialView didScrollToIndex:(NSUInteger)index {
    self.sliderView.value = kSliderOrginValue;
    if ([self.delegate respondsToSelector:@selector(filterBarView:materialDidScrollToIndex:)]) {
        [self.delegate filterBarView:self materialDidScrollToIndex:index];
    }
}

#pragma mark - SCFilterCategoryViewDelegate

- (void)filterCategoryView:(SCFilterCategoryView *)filterCategoryView didScrollToIndex:(NSUInteger)index {
    NSInteger currentIndex = filterCategoryView.currentIndex;
    self.switchLabel.text = @"美颜";
    self.switchView.hidden = NO;
    self.sliderType = SCFilterBarViewFilterTypeBeautify;
    if (currentIndex == 0) {
        self.filterMaterialView.itemList = self.defaultFilterMaterials;
    } else if (currentIndex == 1) {
        self.filterMaterialView.itemList = self.tikTokFilterMaterials;
    } else if (currentIndex == 2) {
        self.filterMaterialView.itemList = self.splitFilterMaterials;
    } else if (currentIndex == 3) {
        self.switchLabel.text = @"颜色";
        self.switchView.hidden = YES;
        self.sliderType = SCFilterBarViewFilterTypeColor;
        self.filterMaterialView.itemList = self.colorFilterMaterials;
    }
    
    if ([self.delegate respondsToSelector:@selector(filterBarView:categoryDidScrollToIndex:)]) {
        [self.delegate filterBarView:self categoryDidScrollToIndex:index];
    }
}

@end
