//
//  ClassDetailViewShower.h
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/18.
//  Copyright © 2020 Redrock. All rights reserved.
//完成显示备忘弹窗、某课详情弹窗操作的类

#import <UIKit/UIKit.h>
#import "LessonView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassDetailViewShower : UIView<LessonViewDelegate>
@property (nonatomic,strong)NSArray <NSDictionary*>*courseDataDictArray;
@property (nonatomic,strong)NSArray <NoteDataModel*>*noteDataModelArray;
@end

NS_ASSUME_NONNULL_END
