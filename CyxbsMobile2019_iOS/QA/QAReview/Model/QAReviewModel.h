//
//  QAReviewModel.h
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/21.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAReviewModel : NSObject


@property(strong,nonatomic)NSArray *reviewData;

- (void)getDataWithId:(NSNumber *)answerId;
- (void)replyComment:(NSString *)content answerId:(NSNumber *)answerId;


- (void)praise:(nonnull NSNumber *)answerId;
- (void)cancelPraise:(nonnull NSNumber *)answerId;

- (void)report:(NSString *)type answer_id:(NSNumber *)answer_id;
@end

NS_ASSUME_NONNULL_END
