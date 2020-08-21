//
//  LessonView.m
//  CyxbsMobile2019_iOS
//
//  Created by Stove on 2020/8/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "LessonView.h"
@interface LessonView()

/// 课程名称
@property(nonatomic,strong)UILabel *courseNameLabel;

/// 教室名
@property(nonatomic,strong)UILabel *classroomNameLabel;

/// 课程时长
@property(nonatomic,assign)int period;

/// 周几的课，hash_day=3代表周四
@property(nonatomic,assign)int hash_day;

/// 第几节大课，hash_lesson=2代表第3节大课，也就是5-6节
@property(nonatomic,assign)int hash_lesson;

//@property(nonatomic,assign)BOOL isNoted;

/// 提醒是只有一节课还是有多节课
@property(nonatomic,strong)UIView *tipView;
@end
@implementation LessonView

- (instancetype)init{
    self = [super init];
    if(self){
        [self setUpUI];
        [self addTipView];
        self.noteDataModelArray = @[];
        UITapGestureRecognizer *TGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouched)];
        [self addGestureRecognizer:TGR];
    }
    return self;
}

/// 给两个label分配空间，同时，把定死的参数配好
- (void)setUpUI{
    self.layer.cornerRadius = 8;
    self.courseNameLabel = [[UILabel alloc] init];
    self.courseNameLabel.font = [UIFont fontWithName:@".PingFang SC" size: 11];
    self.courseNameLabel.numberOfLines = 4;
    [self addSubview:self.courseNameLabel];
    [self.courseNameLabel setTextAlignment:(NSTextAlignmentCenter)];
    
    self.classroomNameLabel = [[UILabel alloc] init];
    self.classroomNameLabel.font = [UIFont fontWithName:@".PingFang SC" size: 11];
    self.classroomNameLabel.numberOfLines = 3;
    [self.classroomNameLabel setTextAlignment:(NSTextAlignmentCenter)];
    [self addSubview:self.classroomNameLabel];
}

/// 更新显示的课表数据，调用前需确保已经对self.courseDataDict进行更新、且已经调用了setUpUI
- (void)setUpData{
    //根据备忘和课的总数判断是否显示提示view
    if(self.courseDataDictArray.count+self.noteDataModelArray.count>1){
        self.tipView.hidden = NO;
    }else{
        self.tipView.hidden = YES;
    }
    //选取self.courseDataDictArray的第一个课用来显示课信息
    self.courseDataDict = [self.courseDataDictArray firstObject];
    //根据self.courseDataDict对子控件的数据更新：
    self.courseNameLabel.text = self.courseDataDict[@"course"];
    self.classroomNameLabel.text = self.courseDataDict[@"classroom"];
    
    NSString *hash_day = self.courseDataDict[@"hash_day"];
    self.hash_day = [hash_day intValue];
    
    NSString *hash_lesson = self.courseDataDict[@"hash_lesson"];
    self.hash_lesson = [hash_lesson intValue];
    
    NSString *period = self.courseDataDict[@"period"];
    self.period = [period intValue];
    
    UIColor *textColor;
    if(self.isEmptyLesson==YES){self.backgroundColor = [UIColor clearColor];}else{
        switch (self.hash_lesson) {
            case 0:
            case 1:
                if(@available(iOS 11.0, *)){
                    self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue<2"];
                    textColor = [UIColor colorNamed:@"ClassLabelColor1"];
                }else{
                    self.backgroundColor = [UIColor colorWithRed:249/255.0 green:231/255.0 blue:216/255.0 alpha:1.0];
                    textColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:21/255.0 alpha:1.0];
                }
                break;
                
                
            case 2:
            case 3:
            if(@available(iOS 11.0, *)){
                self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue>=2&&hash_lesson.integerValue<4"];
                textColor = [UIColor colorNamed:@"ClassLabelColor2"];
            }else{
                self.backgroundColor = [UIColor colorWithRed:249/255.0 green:227/255.0 blue:228/255.0 alpha:1.0];
                textColor = [UIColor colorWithRed:255/255.0 green:98/255.0 blue:98/255.0 alpha:1.0];
            }
            break;
            
                
            default:
                if(@available(iOS 11.0, *)){
                    self.backgroundColor = [UIColor colorNamed:@"hash_lesson.integerValue>4"];
                    textColor = [UIColor colorNamed:@"ClassLabelColor3"];
                }else{
                    self.backgroundColor = [UIColor colorWithRed:221/255.0 green:227/255.0 blue:248/255.0 alpha:1.0];
                    textColor = [UIColor colorWithRed:64/255.0 green:102/255.0 blue:234/255.0 alpha:1.0];
                }
                break;
        }
    }
    self.courseNameLabel.textColor = textColor;
    self.classroomNameLabel.textColor = textColor;
    
    //对自己的frame更新：
    self.frame = CGRectMake(self.hash_day*(LESSON_W+DISTANCE_W), self.hash_lesson*(2*LESSON_H+DISTANCE_H), LESSON_W, self.period*LESSON_H);
    [self addConstraint];
}

/// 加约束，调用前需确保两个label都已经加入父view
- (void)addConstraint{
    [self.courseNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(self.frame.size.height*0.0727);
        make.width.equalTo(self).multipliedBy(0.7234);
    }];
    
    [self.classroomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-self.frame.size.height*0.0455);
        make.width.equalTo(self).multipliedBy(0.7234);
    }];
}

//self被点击后调用
- (void)viewTouched{
    
    if(self.isEmptyLesson==YES){
        
        if(self.noteDataModelArray.count==0){
            
            [self.addNoteDelegate addNoteWithEmptyLessonData:self.emptyClassDate];
        }else{
            self.delegate.courseDataDictArray = @[];
            self.delegate.noteDataModelArray = self.noteDataModelArray;
            [self.delegate showDetail];
        }
    }else{
        
        self.delegate.courseDataDictArray = self.courseDataDictArray;
        self.delegate.noteDataModelArray = self.noteDataModelArray;
        [self.delegate showDetail];
    }
}
///由LessonViewForAWeek调用，添加备忘
- (void)addNoteLabelWithNoteDataModel:(NoteDataModel*)model{
    if(model==nil)return;
    
    NSMutableArray *tempA;
    //如果是有课或者是已经添加过备忘，那就不加备忘信息在课表上
    if(self.isEmptyLesson==NO||self.noteDataModelArray.count!=0){
        tempA = [self.noteDataModelArray mutableCopy];
        [tempA addObject:model];
        self.noteDataModelArray = tempA;
        
        //根据备忘和课的总数判断是否显示提示view
        if(self.courseDataDictArray.count+self.noteDataModelArray.count>1+self.isEmptyLesson){
            self.tipView.hidden = NO;
        }else{
            self.tipView.hidden = YES;
        }
        return;
    }
    
    tempA = [self.noteDataModelArray mutableCopy];
    [tempA addObject:model];
    self.noteDataModelArray = tempA;
    
    //根据备忘和课的总数判断是否显示提示view
    if(self.courseDataDictArray.count+self.noteDataModelArray.count>1+self.isEmptyLesson){
        self.tipView.hidden = NO;
    }else{
        self.tipView.hidden = YES;
    }
    
   
    
    UILabel *titleLab = [self getLabel];
    [self addSubview:titleLab];
    
    titleLab.text = model.noteTitleStr;
    titleLab.numberOfLines = 0;
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.01067*MAIN_SCREEN_W);
        make.right.equalTo(self).offset(-0.01067*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.016*MAIN_SCREEN_W);
    }];
    
    
    UILabel *detailLab = [self getLabel];
    [self addSubview:detailLab];
    
    detailLab.text = model.noteDetailStr;
    detailLab.numberOfLines = 0;
    
    [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.01067*MAIN_SCREEN_W);
        make.right.equalTo(self).offset(-0.01067*MAIN_SCREEN_W);
        make.bottom.equalTo(self).offset(-0.016*MAIN_SCREEN_W);
    }];
    
    
}

- (UILabel*)getLabel{
    UILabel *label = [[UILabel alloc] init];
    
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    label.font = [UIFont fontWithName:PingFangSCRegular size:11];
    [label setTextAlignment:(NSTextAlignmentCenter)];
    
    return label;
}

- (void)addTipView{
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    self.tipView = view;
    
    if (@available(iOS 11.0, *)) {
        view.backgroundColor = [UIColor colorNamed:@"color21_49_91&#F0F0F2"];
    } else {
        view.backgroundColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    view.hidden = YES;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0.092*MAIN_SCREEN_W);
        make.top.equalTo(self).offset(0.012*MAIN_SCREEN_W);
        make.width.mas_equalTo(0.0213*MAIN_SCREEN_W);
        make.height.mas_equalTo(0.008*MAIN_SCREEN_W);
    }];
}
@end




//"begin_lesson" = 1;
//教室                                classroom = 2217;
//课程名称                        course = "高等数学A(下)";
//                                    "course_num" = A1110310;
//                                    day = "星期一";
//周几的课                        "hash_day" = 0;
//从第几节开始上                  "hash_lesson" = 0;
//                                    lesson = "一二节";
//这节课的时长                    period = 2;
//                                    rawWeek = "3-17周";
//                                    teacher = "邓志颖";
//                                    type = "必修";
//  那些周有课                    week =         (
//                                                            3,
//                                                          5,
//                                                            7,
//                                                            9,
//                                                            11,
//                                                            13,
//                                                            15,
//                                                            17
//                                                  );
//                                        weekBegin = 3;
//                                        weekEnd = 17;
//                                        weekModel = single;
