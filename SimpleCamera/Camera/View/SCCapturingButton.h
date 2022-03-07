//
//  SCCapturingButton.h
//  SimpleCamera
//
//  Created by maxslma on 2022/1/6.
//

#import <UIKit/UIKit.h>

@class SCCapturingButton;

/**
  按钮状态

  - SCCapturingButtonStateNormal: 默认
  - SCCapturingButtonStateRecording: 录制中
  */
typedef NS_ENUM(NSUInteger, SCCapturingButtonState) {
    SCCapturingButtonStateNormal,
    SCCapturingButtonStateRecording,
};

@protocol SCCapturingButtonDelegate <NSObject>

/**
 拍照按钮被点击
 */
- (void)capturingButtonDidClicked:(SCCapturingButton *)button;

@end


@interface SCCapturingButton : UIButton

@property (nonatomic, assign) SCCapturingButtonState capturingState;
@property (nonatomic, weak) id <SCCapturingButtonDelegate> delegate;

@end
