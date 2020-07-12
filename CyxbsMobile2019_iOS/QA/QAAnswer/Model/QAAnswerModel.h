//
//  QAAnswerModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAAnswerModel : NSObject
@property(strong,nonatomic)NSString *answerId;
- (void)commitAnswer:(NSNumber *)questionId content:(NSString *)content imageArray:(NSArray *)imageArray;
- (void)uploadPhoto:(NSArray *)photoArray;

//保存到草稿箱
- (void)addItemInDraft:(NSString *)title questionId:(NSNumber *)questionId;
//更新草稿箱
- (void)updateItemInDraft:(NSString *)title draftId:(NSNumber *)draftId;
@end

NS_ASSUME_NONNULL_END
