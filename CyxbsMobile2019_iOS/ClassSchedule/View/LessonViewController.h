//
//  LessonViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LessonViewController : UIViewController
- (instancetype)initWithDataArray:(NSArray*)dataArray;
@property(nonatomic,strong)NSArray *weekDataArray;

/// 代表是第week周的课，0就是整学期
@property(nonatomic,assign)int week;
@end

NS_ASSUME_NONNULL_END
