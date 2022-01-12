//
//  SCFilterMaterialView.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <UIKit/UIKit.h>

#import "SCFilterMaterialModel.h"

@class SCFilterMaterialView;

@protocol SCFilterMaterialViewDelegate <NSObject>

- (void)filterMaterialView:(SCFilterMaterialView *)filterMaterialView didScrollToIndex:(NSUInteger)index;

@end

@interface SCFilterMaterialView : UIView

@property (nonatomic, copy) NSArray<SCFilterMaterialModel *> *itemList;
@property (nonatomic, weak) id <SCFilterMaterialViewDelegate> delegate;

@end
