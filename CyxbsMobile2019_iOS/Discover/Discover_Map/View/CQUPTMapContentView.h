//
//  CQUPTMapContentView.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQUPTMapContentViewDelegate <NSObject>

- (void)backButtonClicked;

@end

NS_ASSUME_NONNULL_BEGIN

@class CQUPTMapDataItem, CQUPTMapHotPlaceItem;
@interface CQUPTMapContentView : UIView

@property (nonatomic, weak) id<CQUPTMapContentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andMapData:(CQUPTMapDataItem *)mapDataItem andHotPlaceItemArray:(NSArray<CQUPTMapHotPlaceItem *> *)hotPlaceItemArray;

@end

NS_ASSUME_NONNULL_END
