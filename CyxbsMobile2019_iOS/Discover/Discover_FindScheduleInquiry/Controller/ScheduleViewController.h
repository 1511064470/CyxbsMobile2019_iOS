//
//  ScheduleViewController.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/7/14.
//  Copyright © 2020 Redrock. All rights reserved.
//对于这个控制器的说明：查询老师课表、查询学生课表是分别由两个控制器管理的，而这两个控制器的类型都是本控制器

#import <UIKit/UIKit.h>
#import "SchedulForOneWeekController.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ScheduleViewControllerDelegate <NSObject>

/**需要跳转到符合条件的学生(或者老师)列表时调用*/
-(void) pushToController:(UIViewController*) peopleListVC;

@end

@interface ScheduleViewController : UIViewController

/**实现符合条件的学生(或者老师)列表的代理*/
@property (nonatomic, weak)id <ScheduleViewControllerDelegate> delegate;

/**参数key是用来当作从缓存取搜索记录数组时需要的UserDefaultKey */
- (instancetype)initWithUserDefaultKey:(NSString*)key;

/***/
- (instancetype)initWithUserDefaultKesy:(NSString*)key;

@property (nonatomic,assign)PeopleType peopleType;

@end

NS_ASSUME_NONNULL_END
