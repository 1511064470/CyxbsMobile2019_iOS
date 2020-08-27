//
//  VolunteerView.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/6/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "VolunteerView.h"
#import "VolunteerItem.h"
///平方字体部分
#define PingFangSC @".PingFang SC"
//Bahnschrift字体部分
#define ImpactMedium @"Impact"
#define ImpactRegular @"Impact"
//颜色部分
#define Color42_78_132 [UIColor colorNamed:@"color42_78_132&#FFFFFF" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]

#define Color21_49_91_F0F0F2  [UIColor colorNamed:@"color21_49_91&#F0F0F2" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
#define Color42_78_132to2D2D2D [UIColor colorNamed:@"Color42_78_132&#2D2D2D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]


@interface VolunteerView()

@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) VolunteerItem *volunteerItem;

@end


@implementation VolunteerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
         if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"colorLikeWhite&#1D1D1D" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
        } else {
            // Fallback on earlier versions
        }
        [self loadUserDefaults];//加载缓存用作视图的初始化
        [self addNoBindingView];
        
        if ([self.defaults objectForKey:@"volunteer_account"]) {
            self.volunteerItem = [NSKeyedUnarchiver unarchiveObjectWithFile:[VolunteerItem archivePath]];
//            [self addBindingView];
        }
        [self addClearButton];//添加透明按钮用来在被点击后设置宿舍
    }
    return self;
}
-(void)refreshViewIfNeeded {
    [self removeUnbindingView];
    [self addBindingView];
}
-(void)removeUnbindingView {
    [self.hintLabel removeFromSuperview];
}
- (void)loadUserDefaults {
    NSUserDefaults *defualts = [NSUserDefaults standardUserDefaults];
    self.defaults = defualts;
}
-(void) addClearButton {
    UIButton * button = [[UIButton alloc]init];
    [button addTarget:self action:@selector(touchSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}
//被点击时调用的方法
-(void)touchSelf {
    if ([self.delegate respondsToSelector:@selector(touchVolunteerView)]) {
        [self.delegate touchVolunteerView];
    }
}
// MARK: 未绑定部分
-(void)addNoBindingView {
    [self addSeperateLine];//一个像素的分割线
    [self addVolunteerTitle];
    [self addAllTimeBackImage];
    [self addHintLabel];
    }
- (void)addSeperateLine {
    UIView *line = [[UIView alloc]init];
    if (@available(iOS 11.0, *)) {
        line.backgroundColor = Color42_78_132to2D2D2D;
    } else {
        line.backgroundColor = [UIColor colorWithRed:232/255.0 green:223/255.0 blue:241/255.0 alpha:1];
    }
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.equalTo(@1);
    }];
}
- (void)addHintLabel {
    UILabel *hintLabel = [[UILabel alloc]init];
    self.hintLabel = hintLabel;
    hintLabel.text = @"还未绑定志愿者账号哦～";
    hintLabel.font = [UIFont fontWithName:PingFangSCLight size: 15];
    if (@available(iOS 11.0, *)) {
        hintLabel.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:hintLabel];
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.allTimeBackImage);
        make.left.equalTo(self.allTimeBackImage.mas_right).offset(22);
    }];
}
- (void)addVolunteerTitle {
    UILabel *title = [[UILabel alloc]init];//左上角标题
    self.volunteerTitle = title;
    title.text = @"志愿时长";
    title.font = [UIFont fontWithName:PingFangSCBold size: 18];
    if (@available(iOS 11.0, *)) {
        title.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self addSubview:title];
    [self.volunteerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(14);
        make.top.equalTo(self).offset(30);
    }];
}
- (void)addAllTimeBackImage {
    UIImageView *allTimeBackImage = [[UIImageView alloc]init];
    self.allTimeBackImage = allTimeBackImage;
    [allTimeBackImage setImage:[UIImage imageNamed:@"志愿时长"]];
    [self addSubview:allTimeBackImage];
    [self addAllTime];
    [self addShi];
    [self.allTimeBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.volunteerTitle);
        make.top.equalTo(self.volunteerTitle.mas_bottom).offset(16);
        make.width.height.equalTo(@64);
    }];
}
- (void)addAllTime {
    UILabel *allTime = [[UILabel alloc]init];
    self.allTime = allTime;
    allTime.text = @"0";
    allTime.font = [UIFont fontWithName:ImpactRegular size:36];
    if (@available(iOS 11.0, *)) {
        allTime.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self.allTimeBackImage addSubview:allTime];
    [self.allTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.allTimeBackImage);
        make.centerY.equalTo(self.allTimeBackImage).offset(2);
    }];
}
- (void)addShi {
    UILabel *shi = [[UILabel alloc]init];
    self.shi = shi;
    shi.text = @"时";
    shi.font = [UIFont fontWithName:PingFangSCBold size:10];
    if (@available(iOS 11.0, *)) {
        shi.textColor = Color42_78_132;
    } else {
        // Fallback on earlier versions
    }
    [self.allTimeBackImage addSubview:shi];
    [self.shi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.allTimeBackImage).offset(-5.5);
        make.bottom.equalTo(self.allTime).offset(-7);
    }];
}
//MARK: 已绑定部分
- (void)addBindingView {
    [self addRecentTitle];
    [self addRecentDate];
    [self addRecentTime];
    [self addRecentTeam];
}

- (void)addRecentTitle {
    UILabel *recentTitle = [[UILabel alloc]init];
    self.recentTitle = recentTitle;
    recentTitle.text = @"测试标题";
    recentTitle.font = [UIFont fontWithName: PingFangSCRegular size:15];
    if (@available(iOS 11.0, *)) {
        recentTitle.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    [self.volunteer addSubview:recentTitle];
    [self.recentTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.volunteerTitle.mas_right).offset(22);
        make.top.equalTo(self.allTimeBackImage);
    }];
}
- (void)addRecentDate {
    UILabel *recentDate = [[UILabel alloc]init];
    self.recentDate = recentDate;
    recentDate.text = @"2019.8.2";
    recentDate.font = [UIFont fontWithName:PingFangSCLight size: 10];
    if (@available(iOS 11.0, *)) {
        recentDate.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    recentDate.alpha = 0.54;
    [self.volunteer addSubview:recentDate];
    [self.recentDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recentTitle);
        make.right.equalTo(self).offset(-15);
    }];
}
- (void)addRecentTime {
    UILabel *recentTime = [[UILabel alloc]init];
    self.recentTime = recentTime;
    recentTime.text = @"5小时";
    recentTime.font = [UIFont fontWithName:PingFangSCLight size: 13];
    if (@available(iOS 11.0, *)) {
        recentTime.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    recentTime.alpha = 0.8;
    [self.volunteer addSubview:recentTime];
    [self.recentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recentTitle);
        make.top.equalTo(self.recentTitle.mas_bottom).offset(4);
    }];
}
- (void)addRecentTeam {
    UILabel *recentTeam= [[UILabel alloc]init];
    self.recentTeam = recentTeam;
    recentTeam.text = @"红领巾志愿服务小分队";
    recentTeam.font = [UIFont fontWithName:PingFangSCLight size: 13];
    if (@available(iOS 11.0, *)) {
        recentTeam.textColor = Color21_49_91_F0F0F2;
    } else {
        // Fallback on earlier versions
    }
    recentTeam.alpha = 0.8;
    [self.volunteer addSubview:recentTeam];
    [self.recentTeam mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.recentTime);
        make.top.equalTo(self.recentTime.mas_bottom).offset(4);
    }];
}
@end
