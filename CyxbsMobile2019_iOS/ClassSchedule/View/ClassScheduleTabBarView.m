//
//  ClassScheduleTabBarView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/3/29.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "ClassScheduleTabBarView.h"
#import "WYCClassBookViewController.h"
@interface ClassScheduleTabBarView ()

@property (nonatomic, weak) UIView *bottomCoverView;
@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, weak) UIView *dragHintView;
@property (nonatomic, assign)BOOL isPresenting;
//@property (nonatomic,assign)BOOL isLoaded;
//用户的课表
@property (nonatomic, strong)WYCClassBookViewController *mySchedul;
@end

@implementation ClassScheduleTabBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"peopleListViewBackColor"];
               } else {
                  self.backgroundColor = [UIColor whiteColor];
               }
        // 遮住下面两个圆角
        UIView *bottomCoverView = [[UIView alloc] init];
        bottomCoverView.backgroundColor = self.backgroundColor;
        [self addSubview:bottomCoverView];
        self.bottomCoverView = bottomCoverView;
        
        UIView *dragHintView = [[UIView alloc] init];
        
        if (@available(iOS 11.0, *)) {
            dragHintView.backgroundColor = [UIColor colorNamed:@"draghintviewcolor"];
        } else {
            // Fallback on earlier versions
            dragHintView.backgroundColor = [UIColor whiteColor];
        }
        dragHintView.layer.cornerRadius = 2.5;
        [self addSubview:dragHintView];
        self.dragHintView = dragHintView;
        
        UILabel *classLabel = [[UILabel alloc] init];
        classLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:22];
        [self addSubview:classLabel];
        self.classLabel = classLabel;
        
        UIImageView *clockImageView = [[UIImageView alloc] init];
        [clockImageView setImage:[UIImage imageNamed:@"nowClassTime"]];
        [self addSubview:clockImageView];
        self.clockImageView = clockImageView;
        
        UILabel *classTimeLabel = [[UILabel alloc] init];
        classTimeLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        [self addSubview:classTimeLabel];
        self.classTimeLabel = classTimeLabel;
        
        UIImageView *locationImageView = [[UIImageView alloc] init];
        [locationImageView setImage:[UIImage imageNamed:@"nowLocation"]];
        [self addSubview:locationImageView];
        self.locationImageView = locationImageView;
        
        UILabel *classroomLabel = [[UILabel alloc] init];
        classroomLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:12];
        [self addSubview:classroomLabel];
        self.classroomLabel = classroomLabel;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMySchedul)
            name:@"Login_LoginSuceeded" object:nil];
        UserItem *item = [UserItem defaultItem];
        if(item.realName!=nil){
//            [self addGesture];
            [self initMySchedul];
            
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bottomCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@16);
    }];
    
    [self.dragHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@27);
        make.height.equalTo(@5);
        make.top.equalTo(self).offset(4);
        make.centerX.equalTo(self);
    }];
    
    [self.classLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(23);
        make.centerY.equalTo(self);
    }];
    
    [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.classLabel.mas_trailing).offset(22);
        make.centerY.equalTo(self.classLabel);
        make.height.width.equalTo(@11);
    }];
    
    [self.classTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.clockImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.classLabel);
    }];
    
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.classTimeLabel.mas_trailing).offset(22);
        make.centerY.equalTo(self.classLabel);
        make.height.width.equalTo(@11);
    }];
    
    [self.classroomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.locationImageView.mas_trailing).offset(3);
        make.centerY.equalTo(self.classLabel);
    }];
}

/// 课表的一个代理方法，用来更新下节课信息
/// @param paramDict 下节课的数据字典
- (void)updateSchedulTabBarViewWithDic:(NSDictionary *)paramDict{
    if( [paramDict[@"is"] intValue]==1){//有下一节课
        self.classroomLabel.text = paramDict[@"classroomLabel"];
        self.classTimeLabel.text = paramDict[@"classTimeLabel"];
        self.classLabel.text = paramDict[@"classLabel"];
    }else{//无下一节课
        self.classroomLabel.text = @"无课了";
        self.classTimeLabel.text = @"无课了";
        self.classLabel.text = @"无课了";
    }
}

/// 添加一个上拉后显示弹窗的手势
- (void)addGesture{
    UIPanGestureRecognizer *PGR = [[UIPanGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        if(self.isPresenting==NO){
            self.isPresenting = YES;
            [self.viewController presentViewController:self.mySchedul animated:YES completion:^{
               self.isPresenting = NO;
            }];
        }
    }];
    [self addGestureRecognizer:PGR];
}

/// 初始化课表，课表控制器是这个类的一个属性
- (void)initMySchedul{
    
    self.mySchedul = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WYCClassBookViewController"];
    
    self.mySchedul.idNum = [UserDefaultTool getIdNum];
    
    self.mySchedul.stuNum = [UserDefaultTool getStuNum];
    
    self.mySchedul.schedulType = ScheduleTypePersonal;
    
    WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc]init];
    
    self.mySchedul.model = model;
    
    model.delegate = self.mySchedul;
    
    model.writeToFile = YES;
    
    [model setValue:@"YES" forKey:@"remindDataLoadFinish"];
    
    if (self.mySchedul.stuNum) {
        [model getClassBookArrayFromNet:self.mySchedul.stuNum];
    }
    
    
    self.mySchedul.schedulTabBar = self;
    
    [self.mySchedul viewWillAppear:YES];
    
    [self addGesture];
}
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//}
@end
