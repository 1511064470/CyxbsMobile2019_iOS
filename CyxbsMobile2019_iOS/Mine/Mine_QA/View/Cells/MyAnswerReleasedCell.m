//
//  MyAnswerReleasedCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/25.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyAnswerReleasedCell.h"
#import "MineQAMyAnswerItem.h"

@interface MyAnswerReleasedCell ()

@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIImageView *integralImageView;
@property (nonatomic, weak) UILabel *integralLabel;
@property (nonatomic, weak) UILabel *isSolvedLabel;
@property (nonatomic, assign) BOOL isSolved;
@property (nonatomic, weak) UIView *separateLine;

@end

@implementation MyAnswerReleasedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 背景颜色
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
        } else {
            // Fallback on earlier versions
        }
        
        // 内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"楼主从乡下考学出来，自力更生，白手起家，过上了有车有房伪中产生活。你们攻击楼主就是嫉妒。";
        contentLabel.numberOfLines = 1;
        contentLabel.font = [UIFont systemFontOfSize:15];
        if (@available(iOS 11.0, *)) {
            contentLabel.textColor = [UIColor colorNamed:@"Mine_QA_ContentLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
        
        // 时间
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"2019.8.22";
        timeLabel.font = [UIFont systemFontOfSize:11];
        if (self.isSolved) {
            timeLabel.textColor = [UIColor colorWithRed:11/255.0 green:204/255.0 blue:240/255.0 alpha:1.0];
        } else {
            if (@available(iOS 11.0, *)) {
                timeLabel.textColor = [UIColor colorNamed:@"Mine_QA_TimeLabelColor"];
            } else {
                // Fallback on earlier versions
            }
        }
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        
        // 积分
        UIImageView *integralImageView = [[UIImageView alloc] init];
        integralImageView.image = [UIImage imageNamed:@"邮问积分"];
        [self.contentView addSubview:integralImageView];
        self.integralImageView = integralImageView;
        
        UILabel *integralLabel = [[UILabel alloc] init];
        integralLabel.text = @"20";
        integralLabel.font = [UIFont systemFontOfSize:11];
        if (@available(iOS 11.0, *)) {
            integralLabel.textColor = [UIColor colorNamed:@"Mine_QA_IntegralLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:integralLabel];
        self.integralLabel = integralLabel;
        
        // 是否解决
        UILabel *isSolvedLabel = [[UILabel alloc] init];
        isSolvedLabel.font = [UIFont systemFontOfSize:11];
        isSolvedLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:isSolvedLabel];
        self.isSolvedLabel = isSolvedLabel;
        
        UIView *separateLine = [[UIView alloc] init];
        if (@available(iOS 11.0, *)) {
            separateLine.backgroundColor = [UIColor colorNamed:@"Mine_QA_SeparateLineColor"];
        } else {
            separateLine.backgroundColor = [UIColor colorWithRed:192/255.0 green:204/255.0 blue:227/255.0 alpha:1];
        }
        [self addSubview:separateLine];
        self.separateLine = separateLine;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(19);
        make.top.equalTo(self).offset(21);
        make.trailing.equalTo(self.contentView).offset(-18);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentLabel);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(9);
    }];
    
    [self.integralImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.trailing.equalTo(self.integralLabel.mas_leading).offset(-5);
        make.height.width.equalTo(@19);
    }];
    
    [self.integralLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.trailing.equalTo(self.isSolvedLabel.mas_leading).offset(-22);
    }];
    
    [self.isSolvedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeLabel);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@22);
        make.width.equalTo(@52);
    }];
    self.isSolvedLabel.layer.cornerRadius = 11;
    self.isSolvedLabel.clipsToBounds = YES;
    
    [self.separateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
}

#pragma mark - setter {
- (void)setItem:(MineQAMyAnswerItem *)item {
    self.contentLabel.text = item.answerContent;
    self.timeLabel.text = item.answerTime;
    self.integralLabel.text = item.integral;
    self.isSolvedLabel.text = item.type;
    self.isSolved = [item.type isEqualToString:@"已采纳"] ? YES : NO;
    
    self.isSolvedLabel.text = item.type;
    if (self.isSolved) {
        if (@available(iOS 11.0, *)) {
            self.isSolvedLabel.textColor = [UIColor colorNamed:@"Mine_QA_SolvedLabelColor"];
            self.isSolvedLabel.backgroundColor = [UIColor colorNamed:@"Mine_QA_SolvedBackgroundColor"];
        } else {
            // Fallback on earlier versions
        }
    } else {
        if (@available(iOS 11.0, *)) {
            self.isSolvedLabel.textColor = [UIColor colorNamed:@"Mine_QA_DidntSolvedLabelColor"];
            self.isSolvedLabel.backgroundColor = [UIColor colorNamed:@"Mine_QA_DidntSolvedBackgroundColor"];
        } else {
            // Fallback on earlier versions
        }
    }
}

@end
