//
//  MyQuestionsDraftCell.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/22.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MineQAMyQuestionItem;
@interface MyQuestionsReleasedCell : UITableViewCell

@property (nonatomic, weak) UIView *separateLine;
@property (nonatomic, strong) MineQAMyQuestionItem *item;

@end

NS_ASSUME_NONNULL_END
