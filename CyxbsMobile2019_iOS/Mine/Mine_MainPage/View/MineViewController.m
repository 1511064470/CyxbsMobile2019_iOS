//
//  MineViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/10/21.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "MineContentViewProtocol.h"
#import "MinePresenter.h"
#import "EditMyInfoViewController.h"
#import "EditMyInfoTransitionAnimator.h"
#import "EditMyInfoPercentDrivenController.h"

@interface MineViewController () <MineContentViewDelegate, MineContentViewProtocol, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) MinePresenter *presenter;

@end

@implementation MineViewController


#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceded) name:@"Login_LoginSuceeded" object:nil];
    
    // 绑定Presenter
    self.presenter = [[MinePresenter alloc] init];
    [self.presenter attachView:self];
    
    // 加载邮问数据
    [self.presenter requestQAInfo];
    
    // 添加contentView
    MineContentView *contentView = [[MineContentView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    contentView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    UserItem *user = [UserItemTool defaultItem];
    self.contentView.headerView.nicknameLabel.text = user.nickname;
    
    if (user.introduction.length == 0) {
        self.contentView.headerView.introductionLabel.text = @"写下你想对世界说的话，就现在";
    } else {
        self.contentView.headerView.introductionLabel.text = user.introduction;
    }
    
    self.contentView.headerView.signinDaysLabel.text = [NSString stringWithFormat:@"已连续签到%@天", user.checkInDay];
    
    NSURL *headerImageURL = [NSURL URLWithString:[UserItemTool defaultItem].headImgUrl];
    [self.contentView.headerView.headerImageView sd_setImageWithURL:headerImageURL placeholderImage:[UIImage imageNamed:@"默认头像"] options:SDWebImageRefreshCached];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.presenter detachView];
}


#pragma mark - ContentView代理
- (void)editButtonClicked {
    EditMyInfoViewController *vc = [[EditMyInfoViewController alloc] init];
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)foldButtonClicked:(UIButton *)foldButton foldState:(BOOL)isFold {
    [UIView animateWithDuration:0.25 animations:^{
        if (isFold) {
            foldButton.transform = CGAffineTransformMakeRotation(-M_PI_2);
        } else {
            foldButton.transform = CGAffineTransformMakeRotation(M_PI_2);
        }
    }];
    [self.contentView.classScheduleTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationFade];
}

- (void)quitButtonClicked:(UIButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录" message:@"退出登录将清除所有账号信息哟，你确定要退出吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *determine = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [UserItemTool logout];
    }];
    [alertController addAction:determine];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)switchedRemindBeforeClass:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_RemindBeforeClass"];
    } else {                    // 关闭开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_RemindBeforeClass"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)switchedRemindEveryDay:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_RemindEveryDay"];
    } else {                    // 关闭开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_RemindEveryDay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)switchedDisplayMemoPad:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_DisplayMemoPad"];
    } else {                    // 关闭开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_DisplayMemoPad"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)switchedLaunchingWithClassScheduleView:(UISwitch *)sender {
    if (sender.on) {            // 打开开关
        [UserDefaultTool saveValue:@"test" forKey:@"Mine_LaunchingWithClassScheduleView"];
    } else {                    // 关闭开关
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Mine_LaunchingWithClassScheduleView"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


#pragma mark - Presenter回调
- (void)QAInfoRequestsSucceeded {
    //邮问数据请求成功
}


#pragma mark - 通知中心回调
// 退出登录后刷新开关，是否折叠等界面信息
- (void)loginSucceded {
    [self.contentView.classScheduleTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
    [self.contentView.appSettingTableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [[EditMyInfoTransitionAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    if (self.panGesture) {
        return [[EditMyInfoTransitionAnimator alloc] initWithPanGesture:self.panGesture];
    } else {
        return [[EditMyInfoTransitionAnimator alloc] init];
    }
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    if (self.panGesture) {
        return [[EditMyInfoPercentDrivenController alloc] initWithPanGesture:self.panGesture];
    } else {
        return nil;
    }
}

@end
