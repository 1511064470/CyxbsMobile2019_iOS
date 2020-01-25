//
//  MyResponseRecievedCell.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/25.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "MyResponseRecievedCell.h"

@interface MyResponseRecievedCell ()

@property (nonatomic, weak) UIImageView *sendingUserImageView;
@property (nonatomic, weak) UILabel *sendingUserNameLabel;
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation MyResponseRecievedCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 背景颜色
        if (@available(iOS 11.0, *)) {
            self.backgroundColor = [UIColor colorNamed:@"Mine_QA_BackgroundColor"];
        } else {
            // Fallback on earlier versions
        }
        
        // 评论者头像
        UIImageView *sendingUserImageView = [[UIImageView alloc] init];
        NSURL *headerImageURL = [NSURL URLWithString:[UserItemTool defaultItem].headImgUrl];
        [sendingUserImageView sd_setImageWithURL:headerImageURL placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached];
        [self.contentView addSubview:sendingUserImageView];
        self.sendingUserImageView = sendingUserImageView;
        
        // 评论者用户名
        UILabel *sendingUserNameLabel = [[UILabel alloc] init];
        sendingUserNameLabel.text = @"@wmtSB!";
        sendingUserNameLabel.font = [UIFont systemFontOfSize:13];
        if (@available(iOS 11.0, *)) {
            sendingUserNameLabel.textColor = [UIColor colorNamed:@"Mine_QA_ContentLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:sendingUserNameLabel];
        self.sendingUserNameLabel = sendingUserNameLabel;
        
        // 评论内容
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = @"lalalallalalalallaa";
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.numberOfLines = 2;
        if (@available(iOS 11.0, *)) {
            contentLabel.textColor = [UIColor colorNamed:@"Mine_QA_ContentLabelColor"];
        } else {
            // Fallback on earlier versions
        }
        [self.contentView addSubview:contentLabel];
        self.contentLabel = contentLabel;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.sendingUserImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(19);
        make.top.equalTo(self.contentView).offset(17);
        make.height.width.equalTo(@48);
    }];
    
    [self.sendingUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sendingUserImageView.mas_trailing).offset(12);
        make.top.equalTo(self.sendingUserImageView);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.sendingUserNameLabel);
        make.bottom.equalTo(self.sendingUserImageView);
    }];
}

@end
