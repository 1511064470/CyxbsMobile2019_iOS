//
//  QADetailAnswerListView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/10.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailAnswerListView.h"

@implementation QADetailAnswerListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = NSStringFromClass(self.class);
        [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.contentView];
    }
    return self;
}
- (void)setupView:(NSDictionary *)dic isSelf:(BOOL)isSelf{
    if (@available(iOS 11.0, *)) {
        self.backgroundColor = [UIColor colorNamed:@"QAListCellColor"];
    } else {
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:252/255.0 alpha:1];
    }
    
    self.answerId = [dic objectForKey:@"id"];
    
    self.adoptBtn.layer.cornerRadius = 10;
    self.adoptBtn.tag = self.answerId.integerValue;
    
    self.separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    self.separateView.alpha = 0.1;
    [self.userNameLabel setText:[dic objectForKey:@"nickname"]];
    NSURL *userIconUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"photo_thumbnail_src"]]];
    
    [self.userIcon setImageWithURL:userIconUrl placeholder:[UIImage imageNamed:@"默认头像"]];
    self.userIcon.layer.cornerRadius = 15;
    
    [self.timeLabel setText:[dic objectForKey:@"created_at"]];
    
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@条回复",[dic objectForKey:@"comment_num"]] forState:UIControlStateNormal];
    self.commentBtn.tag = self.answerId.integerValue;
    
    self.praiseNumLabel.text = [dic objectForKey:@"praise_num"];
    
    NSNumber *is_praised = [dic objectForKey:@"is_praised"];
    if (is_praised.integerValue == 1) {
        [self.praiseBtn setSelected:YES];
    }
    self.praiseBtn.tag = self.answerId.integerValue;
    self.praiseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSNumber *is_adopt = [dic objectForKey:@"is_adopted"];
    if (is_adopt.integerValue == 1 && isSelf) {
        [self.adoptBtn setSelected:YES];
        self.adoptBtn.backgroundColor = [UIColor colorWithHexString:@"#E8F0FC"];
        [self.adoptBtn.titleLabel setTextColor:[UIColor colorWithHexString:@"#94A6C4"]];
    }else if(is_adopt.integerValue == 0 && isSelf){
        [self.adoptBtn setSelected:NO];
    }else{
        self.adoptBtn.hidden = YES;
    }
    [self.contentLabel setText:[dic objectForKey:@"content"]];
    [self.contentLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    
    NSArray *imageUrls = [dic objectForKey:@"photo_url"];
    if (imageUrls.count != 0) {
        self.tapToViewImages.hidden = NO;
        self.tapToViewImages.tag = [[dic objectForKey:@"id"] integerValue];
        [self.tapToViewImages setTitle:[NSString stringWithFormat:@"查看%lu张照片",(unsigned long)imageUrls.count] forState:UIControlStateNormal];
        
    }else{
        self.tapToViewImages.hidden = YES;
    }
    [self.praiseBtn addTarget:self.superview action:@selector(tapPraiseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.adoptBtn addTarget:self.superview action:@selector(tapAdoptBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.tapToViewImages addTarget:self.superview action:@selector(tapToViewBigImage:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tapToViewComment.tag = [self.answerId integerValue];
    //点击进入评论界面
    [self.tapToViewComment addTarget:self.superview action:@selector(tapToViewComment:) forControlEvents:UIControlEventTouchUpInside];
//    [self.commentBtn addTarget:self.superview action:@selector(tapCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
//
    
    UIColor *labelColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    if (@available(iOS 11.0, *)) {
        self.userNameLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.timeLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.contentLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
        self.commentBtn.titleLabel.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
    } else {
        self.userNameLabel.textColor = labelColor;
        self.timeLabel.textColor = labelColor;
        self.contentLabel.textColor = labelColor;
        self.commentBtn.titleLabel.textColor = labelColor;
    }
    
}

@end
