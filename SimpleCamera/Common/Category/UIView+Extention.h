//
//  UIView+Extention.h
//  SimpleCamera
//
//  Created by maxslma on 2022/2/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Extention)

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
