//
//  SCCapturingButton.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <UIKit/UIKit.h>

@class SCCapturingButton;

@protocol SCCapturingButtonDelegate <NSObject>

/**
 拍照按钮被点击
 */
- (void)capturingButtonDidClicked:(SCCapturingButton *)button;

@end


@interface SCCapturingButton : UIButton

@property (nonatomic, weak) id <SCCapturingButtonDelegate> delegate;

@end
