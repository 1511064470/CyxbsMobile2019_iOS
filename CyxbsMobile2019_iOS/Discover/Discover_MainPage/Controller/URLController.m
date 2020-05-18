//
//  URLController.m
//  CyxbsMobile2019_iOS
//
//  Created by 千千 on 2020/5/17.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "URLController.h"
#import <WebKit/WebKit.h>

@interface URLController ()
@property (nonatomic, weak)UIButton *backButton;//返回按钮

@end

@implementation URLController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"ColorBackground" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
    self.navigationController.navigationBar.hidden=YES;
    [self addBackButton];
    WKWebView * webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 100, self.view.width, self.view.height)];
    if(!IS_IPHONEX) {
        webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 75, self.view.width, self.view.height)];
    }
    NSURL * url = [NSURL URLWithString:_toUrl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    // Do any additional setup after loading the view.
}
- (void)addBackButton {
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    self.backButton = button;
    [button setImage:[UIImage imageNamed:@"LQQBackButton"] forState:normal];
    [button setImage: [UIImage imageNamed:@"EmptyClassBackButton"] forState:UIControlStateHighlighted];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        if (IS_IPHONEX) {
            make.top.equalTo(self.view).offset(65);
        }else {
            make.top.equalTo(self.view).offset(40);
        }
        make.left.equalTo(self.view).offset(8.6);
    }];
    [button setImageEdgeInsets:UIEdgeInsetsMake(6, 10, 6, 10)];//增大点击范围
    [button addTarget:self action:@selector(popController) forControlEvents:UIControlEventTouchUpInside];
}
- (void)popController {
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
