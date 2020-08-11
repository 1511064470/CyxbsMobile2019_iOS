//
//  CQUPTMapDataItem.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class CQUPTMapPlaceItem;
@interface CQUPTMapDataItem : NSObject

@property (nonatomic, copy) NSString *hotWord;
@property (nonatomic, copy) NSArray<CQUPTMapPlaceItem *> *placeList;
@property (nonatomic, copy) NSString *mapURL;
@property (nonatomic, copy) NSString *mapColor;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
