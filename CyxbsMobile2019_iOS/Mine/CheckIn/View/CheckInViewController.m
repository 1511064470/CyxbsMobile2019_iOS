//
//  CheckInViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/26.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "CheckInViewController.h"
#import "CheckInProtocol.h"
#import "CheckInPresenter.h"
#import "IntegralStoreViewController.h"
#import "IntegralStoreTransitionAnimator.h"
#import "IntegralStorePercentDrivenController.h"
#import "MyGoodsViewController.h"

@interface CheckInViewController () <CheckInProtocol, CheckInContentViewDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) CheckInPresenter *presenter;

@property (nonatomic, weak) MBProgressHUD *chekingHUD;

@end

@implementation CheckInViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.view.backgroundColor = [UIColor colorNamed:@"Mine_Store_ContainerColor"];
    } else {
        self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:242/255.0 blue:247/255.0 alpha:1];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(integralRefreshSuccess) name:@"IntegralRefreshSuccess" object:nil];
    
    // 绑定Presenter
    self.presenter = [[CheckInPresenter alloc] init];
    [self.presenter attachView:self];
    
    // 添加子视图
    CheckInContentView *contentView = [[CheckInContentView alloc] init];
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    contentView.delegate = self;
    self.contentView = contentView;
}

- (void)viewWillAppear:(BOOL)animated {
    // 从字符串转换日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy.MM.d"];
    NSDate *resDate = [formatter dateFromString:DateStart];
    
    // 计算当前是第几周
    NSInteger beginTime=[resDate timeIntervalSince1970];
    NSDate *now = [NSDate date];
    NSInteger nowTime = [now timeIntervalSince1970];
    double day = (float)(nowTime - beginTime)/(float)86400/(float)7;
    NSInteger nowWeek = (int)ceil(day) - 1;
    
    NSArray *weekArray = @[@"第一周", @"第二周", @"第三周", @"第四周", @"第五周", @"第六周", @"第七周", @"第八周", @"第九周", @"第十周", @"第十一周", @"第十二周", @"第十三周", @"第十四周", @"第十五周", @"第十六周", @"第十七周", @"第十八周", @"第十九周", @"第二十周", @"第二十一周", @"第二十二周", @"第二十三周", @"第二十四周", @"第二十五周"];
    
    if (nowWeek < 0 || nowWeek >= weekArray.count) {
        nowWeek = 0;
    }

    if ([UserItemTool defaultItem].canCheckIn) {
        self.contentView.weekLabel.text = [NSString stringWithFormat:@"上学期%@", weekArray[nowWeek]];
    } else {
        self.contentView.weekLabel.text = @"假期愉快～";
    }
    
    // 过场动画
    [self animationForViewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.presenter dettachView];
    _presenter = nil;
}

- (void)dealloc
{
    NSLog(@"dealloc");
}

- (void)animationForViewWillAppear {
    self.contentView.checkInView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 400);
    self.contentView.storeView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 100);
    
    [UIView animateWithDuration:0.7 delay:0.15 usingSpringWithDamping:1 initialSpringVelocity:7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.checkInView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];

    [UIView animateWithDuration:0.5 delay:0.5 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.storeView.layer.affineTransform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];

}


#pragma mark - 代理回调
- (void)backButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)CheckInButtonClicked:(UIButton *)sender {
    if ([UserItemTool defaultItem].rank.intValue != 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"今天签过到了哦～";
        [hud hide:YES afterDelay:1.5];
        return;
    } else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"正在签到...";
        self.chekingHUD = hud;
    }
    [self.presenter checkIn];
}

- (void)myGoodsButtonTouched {
    MyGoodsViewController *vc = [[MyGoodsViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}


// 手势
- (void)presentIntegralStore:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.presentPanGesture = pan;
        
        IntegralStoreViewController *vc = [[IntegralStoreViewController alloc] init];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self;
        [self presentViewController:vc animated:YES completion:nil];
    }
}


#pragma mark - Presenter回调
- (void)checkInSucceded {
    [self.contentView CheckInSucceded];
    
    [self.chekingHUD hide:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"签到成功";
    [hud hide:YES afterDelay:1.5];
}

- (void)checkInFailed {
    [self.chekingHUD hide:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Σ（ﾟдﾟlll）签到失败了...";
    [hud hide:YES afterDelay:1.5];
}


#pragma mark - 转场动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[IntegralStoreTransitionAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[IntegralStoreTransitionAnimator alloc] init];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.presentPanGesture) {
        return [[IntegralStorePercentDrivenController alloc] initWithPanGesture:self.presentPanGesture];
    } else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.presentPanGesture) {
        return [[IntegralStorePercentDrivenController alloc] initWithPanGesture:self.presentPanGesture];
    } else {
        return nil;
    }
}


#pragma mark - 通知中心
- (void)integralRefreshSuccess {
    self.contentView.scoreLabel.text = [NSString stringWithFormat:@"%@", [UserItemTool defaultItem].integral];
}

@end
