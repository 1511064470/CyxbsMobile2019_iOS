//
//  QADetailViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/20.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QADetailViewController.h"
#import "QAAnswerViewController.h"
#import "QADetailModel.h"
@interface QADetailViewController ()
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)NSNumber *id;
@property(strong,nonatomic)QADetailModel *model;
@end

@implementation QADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:248/255.0 alpha:1.0];
    [self configNavagationBar];
    //    self.scrollView = [[UIScrollView alloc]init];
    //    [self.view addSubview:self.scrollView];
    //    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.bottom.left.right.equalTo(self.view).mas_offset(0);
    //    }];
    //    [self setNavigationBar:@"期末考试高数应该如何复习"];
    
    // Do any additional setup after loading the view.
}

-(void)setNavigationBar:(NSString *)title{
    //设置标题
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    [label setFrame:CGRectMake(0, 0, SCREEN_WIDTH, NVGBARHEIGHT)];
    label.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 23], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    label.attributedText = string;
    label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    label.alpha = 1.0;
    self.navigationItem.titleView = label;
    
    //设置返回按钮样子
    self.navigationController.navigationBar.topItem.title = @"";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHexString:@"#122D55"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0 , 0, 60, 60);
    [button setImage:[UIImage imageNamed:@"moreIcon"] forState:UIControlStateNormal];
    //    [self.view addSubview:button];
    
    // 设置rightBarButtonItem
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
-(void)setScrollView{
    //添加问题详情信息界面
    UIView *view = [[UIView alloc]init];
    
}
-(instancetype)initViewWithId:(NSNumber *)id title:(NSString *)title{
    self = [super init];
    [self setNavigationBar:title];
    self.id = id;
    self.model = [[QADetailModel alloc]init];
    [self setNotification];
    
    [self loadData];
    return self;
}
- (void)configNavagationBar {
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]}];
    //隐藏导航栏的分割线
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorNamed:@"navicolor" inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    } else {
        // Fallback on earlier versions
    }
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
  
    
}
-(void)setupUI{
    //    NSLog(@"%@",self.model.dataDic);
    NSDictionary *dic = self.model.dataDic;
    
    UIView *userInfoView = [[UIView alloc]init];
    userInfoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:userInfoView];
    
    UIImageView *userIcon = [[UIImageView alloc]init];
    NSString *userIconUrl = [dic objectForKey:@"questioner_photo_thumbnail_src"];
    [userIcon setImageWithURL:[NSURL URLWithString:userIconUrl] placeholder:[UIImage imageNamed:@"userIcon"]];
    [userInfoView addSubview:userIcon];
    
    UILabel *userNameLabel = [[UILabel alloc]init];
    userNameLabel.font = [UIFont fontWithName:PingFangSCBold size:15];
    [userNameLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [userNameLabel setText:[dic objectForKey:@"questioner_nickname"]];
    [userInfoView addSubview:userNameLabel];
    
    UILabel *dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont fontWithName:PingFangSCRegular size:11];
    [dateLabel setTextColor:[UIColor colorWithHexString:@"#2A4E84"]];
    NSString *date = [dic objectForKey:@"disappear_at"];
    [dateLabel setText:[date substringWithRange:NSMakeRange(0, 10)]];
    [userInfoView addSubview:dateLabel];
    
    UIImageView *integralIcon = [[UIImageView alloc]init];
    [integralIcon setImage:[UIImage imageNamed:@"integralIcon2"]];
    [userInfoView addSubview:integralIcon];
    
    UILabel *integralNumLabel = [[UILabel alloc]init];
    NSString *integralNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"reward"]];
    [integralNumLabel setText:integralNum];
    integralNumLabel.font = [UIFont fontWithName:PingFangSCRegular size:11];
    [integralNumLabel setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    [userInfoView addSubview:integralNumLabel];
    
    [userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(userInfoView.superview).mas_offset(0);
        make.top.equalTo(userInfoView.superview).mas_offset(TOTAL_TOP_HEIGHT);
        make.height.equalTo(@57);
    }];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userInfoView).mas_offset(16);
        make.top.equalTo(userInfoView).mas_offset(16);
        make.height.width.equalTo(@40);
    }];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).mas_offset(14);
        make.top.mas_equalTo(userIcon.mas_top);
    }];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel);
        make.bottom.equalTo(userIcon);
        //        make.height.equalTo(@57);
    }];
    [integralIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(userInfoView.mas_right).mas_offset(-33);
        make.top.mas_equalTo(userInfoView.mas_top).mas_offset(33);
        make.height.width.mas_equalTo(17);
        //        make.height.equalTo(@57);
    }];
    [integralNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(integralIcon.mas_right).mas_offset(3);
        make.centerY.equalTo(integralIcon);
    }];
    //    UILabel *contentLabel = [[UILabel alloc]init];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    NSString *content = [dic objectForKey:@"description"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"雪莉曾与宋茜、刘逸云(Amber)、朴善怜(Luna)和郑秀晶（Krysal）组成女子流行演唱组合f(x)，因为靓丽的外形与甜美的歌曲，到很多歌迷的喜欢，虽然五人之后因不同的职业规划各自单飞，但依然保持着良好的关系。当听到雪组成女子流行演唱组合f(x)，因为靓丽的外形与甜美的歌曲，到很多歌迷的喜欢，虽然五人之后因不同的职业规划各自单飞，但依然保持着良好的关系。当听到雪组成女子流行演唱组合f(x)，因为靓丽的外形与甜美的歌曲，到很多歌迷的喜欢，虽然五人之后因不同的职业规划各自单飞，但依然保持着良好的关系。当听到雪"  attributes:@{NSFontAttributeName: [UIFont fontWithName:PingFangSCRegular size: 15], NSForegroundColorAttributeName: [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0]}];
    
    contentLabel.attributedText = string;
    contentLabel.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1.0];
    contentLabel.alpha = 1.0;
    
    [self.view addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(userInfoView.mas_bottom).mas_offset(5);
    }];
    
    
//    NSArray *imgUrlArray = [dic objectForKey:@"photo_urls"];
    NSArray *imgUrlArray = @[@"http://img.wenjiwu.com/life/201704/9-1F422105602357.png"];
    UIImageView *imgView = [[UIImageView alloc]init];
    NSString *urlString = [NSString stringWithFormat:@"%@",imgUrlArray[0]];
    NSURL *url = [NSURL URLWithString:urlString];
    [imgView setImageWithURL:url placeholder:[UIImage imageNamed:@"userIcon"]];
    [self.view addSubview:imgView];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(contentLabel.mas_bottom).mas_offset(14);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.height.mas_equalTo(@200);
    }];
//    for (NSString *url in imgUrlArray) {
//    }
    UIView *separateView = [[UIView alloc]init];
    separateView.backgroundColor = [UIColor colorWithHexString:@"#2A4E84"];
    separateView.alpha = 0.1;
    [self.view addSubview:separateView];
    
    [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.top.mas_equalTo(imgView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *askButton = [[UIButton alloc]init];
    askButton.backgroundColor = [UIColor colorWithHexString:@"#4841E2"];
    [askButton setTitle:@"回答" forState:UIControlStateNormal];
    [askButton.titleLabel setFont:[UIFont fontWithName:PingFangSCMedium size:18]];
    askButton.layer.cornerRadius = 20;
    [askButton setTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:askButton];
    [askButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-60);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
    }];
}
-(void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
    [self.model getDataWithId:self.id];
}
-(void)setNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadSuccess)
                                                 name:@"QADetailDataLoadSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadError)
                                                 name:@"QADetailDataLoadError" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QADetailDataLoadFailure)
                                                 name:@"QADetailDataLoadFailure" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadView)
                                                 name:@"QADetailDataReLoad" object:nil];
}

-(void)QADetailDataLoadSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setupUI];
    //    NSLog(@"%D,%@",self.model.dataArray.count, self.model.dataArray[0]);
}
-(void)QADetailDataLoadError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"数据加载错误" message:@"网络数据解析错误" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

-(void)QADetailDataLoadFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
-(void)reloadView{
    //    [self.view removeAllSubviews];
    //    [self addContentView];
    //    [self.model getData];
    
}
-(void)answer:(UIButton *)sender{
    QAAnswerViewController *vc = [[QAAnswerViewController alloc]initWithQuestionId:self.id content:[self.model.dataDic objectForKey:@"description"]];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
