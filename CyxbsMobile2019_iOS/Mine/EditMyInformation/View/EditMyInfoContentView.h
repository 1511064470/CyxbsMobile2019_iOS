//
//  EditMyInfoContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineEditTextField.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditMyInfoContentViewDelegate <NSObject>

- (void)saveButtonClicked:(UIButton *)sender;

@end

@interface EditMyInfoContentView : UIView

@property (nonatomic, weak) id<EditMyInfoContentViewDelegate> delegate;

@property (nonatomic, weak) UIImageView *headerImageView;
@property (nonatomic, weak) MineEditTextField *nicknameTextField;
@property (nonatomic, weak) MineEditTextField *introductionTextField;
@property (nonatomic, weak) MineEditTextField *QQTextField;
@property (nonatomic, weak) MineEditTextField *phoneNumberTextField;
@property (nonatomic, weak) UIButton *academyButton;
@property (nonatomic, weak) UIButton *saveButton;

@end

NS_ASSUME_NONNULL_END
