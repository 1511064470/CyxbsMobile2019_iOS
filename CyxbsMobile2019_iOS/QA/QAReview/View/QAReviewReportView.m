//
//  QAReviewReportView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/4/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAReviewReportView.h"

@implementation QAReviewReportView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = NSStringFromClass(self.class);
        [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);

        self.contentView.layer.cornerRadius = 16;
        
        [self addSubview:self.contentView];
    }
    return self;
}
- (void)setupView{
    for (UIButton *btn in self.reportBtnCollection){
        if (btn.tag == 5) {
            [btn setTitleColor:[UIColor colorWithHexString:@"#4841E2"] forState:UIControlStateNormal];
        }
    }
    self.cancelButton.backgroundColor = [UIColor colorWithHexString:@"#4841E2"];
    [self.cancelButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.cancelButton.layer.cornerRadius = 20;
}
@end
