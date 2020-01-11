//
//  CheckInProtocol.h
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CheckInModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CheckInProtocol <NSObject>

- (void)checkInDataLoadSucceeded:(CheckInModel *)model;

@end

NS_ASSUME_NONNULL_END
