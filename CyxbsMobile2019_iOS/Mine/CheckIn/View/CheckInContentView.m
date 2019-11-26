//
//  CheckInContentVIew.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/26.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "CheckInContentView.h"

@interface CheckInContentView ()

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UILabel *tipsLabel;
@property (nonatomic, weak) UILabel *yearsLabel;
@property (nonatomic, weak) UILabel *weekLabel;
@property (nonatomic, weak) UILabel *daysLabel;
@property (nonatomic, weak) UILabel *checkInRankLabel;
@property (nonatomic, weak) UILabel *checkInRankPercentLabel;
@property (nonatomic, weak) UIButton *checkInButton;
@property (nonatomic, weak) UIView *dragHintView;
@property (nonatomic, weak) UILabel *storeTitlelabel;
@property (nonatomic, weak) UIImageView *scoreImageView;
@property (nonatomic, weak) UILabel *scoreLabel;

@end

@implementation CheckInContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        backgroundImageView.image = [UIImage imageNamed:@"签到背景"];
        backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:backgroundImageView];
        self.backgroundImageView = backgroundImageView;
        
        UILabel *tipsLabel = [[UILabel alloc] init];
        tipsLabel.text = @"半期考试周打卡翻倍";
        tipsLabel.font = [UIFont systemFontOfSize:13];
        [self.backgroundImageView addSubview:tipsLabel];
        tipsLabel.textColor = [UIColor whiteColor];
        self.tipsLabel = tipsLabel;
        
        UILabel *yearsLabel = [[UILabel alloc] init];
        yearsLabel.text = @"2019-2020";
        yearsLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:34];
        yearsLabel.textColor = [UIColor whiteColor];
        [self.backgroundImageView addSubview:yearsLabel];
        self.yearsLabel = yearsLabel;
        
        UILabel *weekLabel = [[UILabel alloc] init];
        weekLabel.text = @"上学期第十三周";
        weekLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:34];
        weekLabel.textColor = [UIColor whiteColor];
        [self.backgroundImageView addSubview:weekLabel];
        self.weekLabel = weekLabel;

        UILabel *daysLabel = [[UILabel alloc] init];
        daysLabel.text = [NSString stringWithFormat:@"已连续打卡%@天", [UserItemTool defaultItem].checkInDay];
        daysLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        daysLabel.textColor = [UIColor whiteColor];
        [self.backgroundImageView addSubview:daysLabel];
        self.daysLabel = daysLabel;
        
        UIView *checkInView = [[UIView alloc] init];
        checkInView.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:248/255.0 alpha:1.0];
        checkInView.layer.cornerRadius = 16;
        [self addSubview:checkInView];
        self.checkInView = checkInView;
        
        UILabel *checkInRankLabel = [[UILabel alloc] init];
        checkInRankLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        checkInRankLabel.text = [NSString stringWithFormat:@"今日第%ld位打卡", self.signInRank];
        checkInRankLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        [checkInView addSubview:checkInRankLabel];
        self.checkInRankLabel = checkInRankLabel;
        
        UILabel *checkInRankPercentLabel = [[UILabel alloc] init];
        checkInRankPercentLabel.textColor = [UIColor colorWithRed:157/255.0 green:165/255.0 blue:170/255.0 alpha:1];
        checkInRankPercentLabel.text = [NSString stringWithFormat:@"超过%d%%的邮子", 60];
        checkInRankPercentLabel.font = [UIFont systemFontOfSize:11];
        [checkInView addSubview:checkInRankPercentLabel];
        self.checkInRankPercentLabel = checkInRankPercentLabel;
        
        UIButton *checkInButton = [UIButton buttonWithType:UIButtonTypeSystem];
        checkInButton.backgroundColor = [UIColor colorWithRed:72/255.0 green:65/255.0 blue:226/255.0 alpha:1];
        [checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        checkInButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [checkInButton setTitle:@"签 到" forState:UIControlStateNormal];
        [checkInView addSubview:checkInButton];
        self.checkInButton = checkInButton;
        
        UIView *storeView = [[UIView alloc] init];
        storeView.backgroundColor = [UIColor whiteColor];
        storeView.layer.cornerRadius = 16;
        [self.checkInView addSubview:storeView];
        self.storeView = storeView;
        
        UILabel *storeTitlelabel = [[UILabel alloc] init];
        storeTitlelabel.text = @"积分商城";
        storeTitlelabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:21];
        storeTitlelabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        [self.storeView addSubview:storeTitlelabel];
        self.storeTitlelabel = storeTitlelabel;
        
        UIImageView *scoreImageView = [[UIImageView alloc] init];
        scoreImageView.image = [UIImage imageNamed:@"积分"];
        [self.storeView addSubview:scoreImageView];
        self.scoreImageView = scoreImageView;
        
        UILabel *scoreLabel = [[UILabel alloc] init];
        scoreLabel.text = [NSString stringWithFormat:@"%@", [UserItemTool defaultItem].integral];
        scoreLabel.font = [UIFont systemFontOfSize:18];
        scoreLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
        [self.storeView addSubview:scoreLabel];
        self.scoreLabel = scoreLabel;
        
        // 提醒用户该view可拖拽
        UIView *dragHintView = [[UIView alloc] init];
        dragHintView.backgroundColor = [UIColor colorWithRed:226/255.0 green:237/255.0 blue:251/255.0 alpha:1.0];
        [self.storeView addSubview:dragHintView];
        self.dragHintView = dragHintView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    if (IS_IPHONEX) {
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(70);
            make.leading.equalTo(self).offset(16);
        }];
    } else {
        [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(55);
            make.leading.equalTo(self).offset(16);
        }];
    }
    
    [self.yearsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(5);
        make.leading.equalTo(self.tipsLabel);
    }];
    
    [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tipsLabel);
        make.top.equalTo(self.yearsLabel.mas_bottom);
    }];
    
    [self.daysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.tipsLabel);
        make.top.equalTo(self.weekLabel.mas_bottom).offset(8);
    }];

    if (IS_IPHONEX) {
        [self.checkInView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(self.mas_height).multipliedBy(0.45);
        }];
    } else {
        [self.checkInView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
            make.height.equalTo(self.mas_height).multipliedBy(0.5);
        }];
    }

    [self.checkInRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.checkInView).offset(13);
        make.top.equalTo(self.checkInView).offset(31);
    }];

    [self.checkInRankPercentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.checkInRankLabel.mas_bottom).offset(4);
        make.leading.equalTo(self.checkInRankLabel);
    }];

    if (IS_IPHONEX) {
        [self.checkInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@40);
            make.width.equalTo(@120);
            make.bottom.equalTo(self.storeView.mas_top).offset(-28);
        }];
    } else {
        [self.checkInButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.height.equalTo(@40);
            make.width.equalTo(@120);
            make.bottom.equalTo(self.storeView.mas_top).offset(-20);
        }];
    }
    self.checkInButton.layer.cornerRadius = 20;

    [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.height.equalTo(@104);
        make.bottom.equalTo(self).offset(16);       // 隐藏下圆角
    }];
    
    [self.dragHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.storeView);
        make.top.equalTo(self.storeView).offset(9);
        make.height.equalTo(@6);
        make.width.equalTo(@30);
    }];
    self.dragHintView.layer.cornerRadius = 3;
    
    [self.storeTitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.storeView).offset(22);
        make.leading.equalTo(self.storeView).offset(13);
    }];
    
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeTitlelabel);
        make.trailing.equalTo(self.storeView).offset(-16);
    }];
    
    [self.scoreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.storeTitlelabel);
        make.trailing.equalTo(self.scoreLabel.mas_leading).offset(-9);
        make.height.width.equalTo(@21);
    }];
}


@end
