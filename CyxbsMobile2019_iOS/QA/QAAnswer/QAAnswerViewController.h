//
//  QAAnswerViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/23.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAAnswerViewController : QABaseViewController
-(instancetype)initWithQuestionId:(NSNumber *)questionId content:(NSString *)content answer:(NSString *)answer;
-(void)initFrpmDraft:(NSNumber *)draft_id;
@end

NS_ASSUME_NONNULL_END
