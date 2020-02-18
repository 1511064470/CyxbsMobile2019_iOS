//
//  EditMyInfoViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2019/11/14.
//  Copyright © 2019 Redrock. All rights reserved.
//

#import "EditMyInfoViewController.h"
#import "EditMyInfoContentView.h"
#import "EditMyInfoPresenter.h"
#import "MineViewController.h"
#import "EditMyInfoView.h"

@interface EditMyInfoViewController () <EditMyInfoContentViewDelegate, UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) EditMyInfoPresenter *presenter;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation EditMyInfoViewController


#pragma mark - Getter & Setter
- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slideToDismiss:)];
    }
    return _panGesture;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.presenter = [[EditMyInfoPresenter alloc] init];
    [self.presenter attachView:self];
    
    EditMyInfoView *editMyInfoView = [[EditMyInfoView alloc] init];
    self.view = editMyInfoView;
    
    EditMyInfoContentView *contentView = [[EditMyInfoContentView alloc] init];
    [self.view addSubview:contentView];
    self.contentView = contentView;
    contentView.delegate = self;
    contentView.contentScrollView.delegate = self;
    [contentView.gestureView addGestureRecognizer:self.panGesture];
    contentView.contentScrollView.delegate = self;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.leading.trailing.equalTo(self.view);
    }];
    
    editMyInfoView.backButton = contentView.backButton;
}

- (void)dealloc
{
    [self.presenter dettatchView];
}


#pragma mark - scrollView代理回调
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


#pragma mark - contentView代理回调
- (void)saveButtonClicked:(UIButton *)sender {
    ((MineViewController *)self.transitioningDelegate).panGesture = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonClicked:(UIButton *)sender {
    ((MineViewController *)self.transitioningDelegate).panGesture = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)headerImageTapped:(UIImageView *)sender {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.allowsEditing = YES;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.contentView.headerImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 手势调用
- (void)slideToDismiss:(UIPanGestureRecognizer *)sender {
    CGPoint translatedPoint = [self.contentView.contentScrollView.panGestureRecognizer locationInView:self.view];
    if (translatedPoint.y > 0) {
        ((MineViewController *)self.transitioningDelegate).panGesture = sender;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    self.contentView.contentScrollView
}

@end
