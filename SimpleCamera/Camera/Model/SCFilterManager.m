//
//  SCFilterManager.m
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import "SCFilterManager.h"

static SCFilterManager *_filterManager;

@interface SCFilterManager ()

@property (nonatomic, strong, readwrite) NSArray<SCFilterMaterialModel *> *defaultFilters;
@property (nonatomic, strong, readwrite) NSArray<SCFilterMaterialModel *> *tikTokFilters;
@property (nonatomic, strong, readwrite) NSArray<SCFilterMaterialModel *> *splitFilters;
@property (nonatomic, strong, readwrite) NSArray<SCFilterMaterialModel *> *colorFilters;

@property (nonatomic, strong) NSDictionary *defaultFilterMaterialsInfo;
@property (nonatomic, strong) NSDictionary *tikTokFilterMaterialsInfo;
@property (nonatomic, strong) NSDictionary *splitFilterMaterialsInfo;
@property (nonatomic, strong) NSDictionary *colorFilterMaterialsInfo;

@property (nonatomic, strong) NSMutableDictionary *filterClassInfo;

@end

@implementation SCFilterManager

+ (SCFilterManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _filterManager = [[SCFilterManager alloc] init];
    });
    return _filterManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

#pragma mark - Public

- (GPUImageFilter *)filterWithFilterID:(NSString *)filterID {
    NSString *className = self.filterClassInfo[filterID];
    
    Class filterClass = NSClassFromString(className);
    return [[filterClass alloc] init];
}

#pragma mark - Private

- (void)commonInit {
    self.filterClassInfo = [[NSMutableDictionary alloc] init];
    [self setupDefaultFilterMaterialsInfo];
    [self setupTikTokFilterMaterialsInfo];
    [self setupSplitFilterMaterialsInfo];
    [self setupColorFilterMaterialsInfo];
}

- (void)setupDefaultFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DefaultFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.defaultFilterMaterialsInfo = [info copy];
}

- (void)setupTikTokFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TikTokFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.tikTokFilterMaterialsInfo = [info copy];
}

- (void)setupSplitFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"SplitFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.splitFilterMaterialsInfo = [info copy];
}

- (void)setupColorFilterMaterialsInfo {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ColorFilterMaterials" ofType:@"plist"];
    NSDictionary *info = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    self.colorFilterMaterialsInfo = [info copy];
}

- (NSArray<SCFilterMaterialModel *> *)setupFiltersWithInfo:(NSDictionary *)info {
    NSMutableArray *mutArr = [[NSMutableArray alloc] init];
    NSArray *defaultArray = info[@"Default"];
    for (NSDictionary *dict in defaultArray) {
        SCFilterMaterialModel *model = [[SCFilterMaterialModel alloc] init];
        model.filterID = dict[@"filter_id"];
        model.filterName = dict[@"filter_name"];
        [mutArr addObject:model];
        self.filterClassInfo[dict[@"filter_id"]] = dict[@"filter_class"];
    }
    return [mutArr copy];
}

#pragma mark - Custom Accessor

- (NSArray<SCFilterMaterialModel *> *)defaultFilters {
    if (!_defaultFilters) {
        _defaultFilters = [self setupFiltersWithInfo:self.defaultFilterMaterialsInfo];
    }
    return _defaultFilters;
}

- (NSArray<SCFilterMaterialModel *> *)tiktokFilters {
    if (!_tikTokFilters) {
        _tikTokFilters = [self setupFiltersWithInfo:self.tikTokFilterMaterialsInfo];
    }
    return _tikTokFilters;
}

- (NSArray<SCFilterMaterialModel *> *)splitFilters {
    if (!_splitFilters) {
        _splitFilters = [self setupFiltersWithInfo:self.splitFilterMaterialsInfo];
    }
    return _splitFilters;
}

- (NSArray<SCFilterMaterialModel *> *)colorFilters {
    if (!_colorFilters) {
        _colorFilters = [self setupFiltersWithInfo:self.colorFilterMaterialsInfo];
    }
    return _colorFilters;
}

@end
