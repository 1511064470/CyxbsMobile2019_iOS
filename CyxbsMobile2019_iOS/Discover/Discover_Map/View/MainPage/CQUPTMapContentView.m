//
//  CQUPTMapContentView.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/8.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapContentView.h"
#import "CQUPTMapHotPlaceButton.h"
#import "CQUPTMapMyStarButton.h"
#import "CQUPTMapDataItem.h"
#import "CQUPTMapPlaceItem.h"
#import "CQUPTMapHotPlaceItem.h"
#import "CQUPTMapStarPlaceItem.h"
#import "CQUPTMapSearchView.h"
#import "CQUPTMapDetailView.h"
#import <IQKeyboardManager.h>

@interface CQUPTMapContentView () <UITextFieldDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, CALayerDelegate>

// 数据
@property (nonatomic, strong) CQUPTMapDataItem *mapDataItem;
@property (nonatomic, copy) NSArray<CQUPTMapHotPlaceItem *> *hotPlaceItemArray;
@property (nonatomic, copy) NSArray<CQUPTMapStarPlaceItem *> *starPlaceArray;

// 控件
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UITextField *searchBar;
@property (nonatomic, weak) UIImageView *searchScopeImageView;
@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, weak) UIScrollView *hotScrollView;
@property (nonatomic, strong) NSMutableArray<CQUPTMapHotPlaceButton *> *hotButtonArray;

@property (nonatomic, weak) CQUPTMapMyStarButton *starButton;
@property (nonatomic, weak) UIImageView *starDialogueBoxImageView;
@property (nonatomic, weak) UITableView *starTableView;

@property (nonatomic, weak) CQUPTMapSearchView *beforeSearchView;

/// 选择地点后底部弹出的view
@property (nonatomic, weak) CQUPTMapDetailView *detailView;

@property (nonatomic, assign) CGFloat lastY;

@end


@implementation CQUPTMapContentView

- (instancetype)initWithFrame:(CGRect)frame andMapData:(CQUPTMapDataItem *)mapDataItem andHotPlaceItemArray:(nonnull NSArray<CQUPTMapHotPlaceItem *> *)hotPlaceItemArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.mapDataItem = mapDataItem;
        self.hotPlaceItemArray = hotPlaceItemArray;
        
        UIView *topView = [[UIView alloc] init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        self.topView = topView;
        
        // 返回按钮
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [backButton setImage:[UIImage imageNamed:@"我的返回"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        self.backButton = backButton;
        
        // 搜索栏
        UITextField *searchBar = [[UITextField alloc] init];
        searchBar.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 0)];
        searchBar.leftViewMode = UITextFieldViewModeAlways;
        searchBar.returnKeyType = UIReturnKeySearch;
        searchBar.font = [UIFont fontWithName:PingFangSCMedium size:14];
        searchBar.placeholder = [NSString stringWithFormat:@"大家都在搜：%@", mapDataItem.hotWord];
        [searchBar.keyboardToolbar.doneBarButton setTarget:self action:@selector(cancelSearch)];
        searchBar.delegate = self;
        [self addSubview:searchBar];
        self.searchBar = searchBar;
        
        UIImageView *searchScopeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Map_Scope"]];
        [searchBar addSubview:searchScopeImageView];
        self.searchScopeImageView = searchScopeImageView;
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancelButton setImage:[UIImage imageNamed:@"Map_CancelSearch"] forState:UIControlStateNormal];
        cancelButton.hidden = YES;
        [self.searchBar addSubview:cancelButton];
        self.cancelButton = cancelButton;
        
        // 热词
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor clearColor];
        scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.hotScrollView = scrollView;
        
        self.hotButtonArray = [NSMutableArray array];
        for (CQUPTMapHotPlaceItem *hotPlace in hotPlaceItemArray) {
            CQUPTMapHotPlaceButton *hotButton = [[CQUPTMapHotPlaceButton alloc] initWithTitle:hotPlace.title hotTag:hotPlace.isHot];
            [self.hotScrollView addSubview:hotButton];
            [self.hotButtonArray addObject:hotButton];
        }
        
        // 收藏
        CQUPTMapMyStarButton *starButton = [[CQUPTMapMyStarButton alloc] init];
        starButton.backgroundColor = [UIColor clearColor];
        [starButton addTarget:self action:@selector(starButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:starButton];
        self.starButton = starButton;
        
        
        // 地图
        UIScrollView *mapScrollView = [[UIScrollView alloc] init];
        mapScrollView.showsVerticalScrollIndicator = NO;
        mapScrollView.showsHorizontalScrollIndicator = NO;
        mapScrollView.delegate = self;
        [self addSubview:mapScrollView];
        self.mapScrollView = mapScrollView;
        
        UIImageView *mapView = [[UIImageView alloc] init];
        mapView.backgroundColor = [UIColor grayColor];
        mapView.image = [UIImage imageNamed:@"Map_map"];
        mapView.contentMode = UIViewContentModeScaleAspectFill;
        mapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
        [mapView addGestureRecognizer:tap];
        [self.mapScrollView addSubview:mapView];
        self.mapView = mapView;
        
        mapScrollView.contentSize = mapView.image.size;
        mapScrollView.maximumZoomScale = 6.0;
        mapScrollView.minimumZoomScale = 1.0;
        [mapScrollView scrollToBottom];
        
        // 深色模式
        if (@available(iOS 11.0, *)) {
            searchBar.backgroundColor = [UIColor colorNamed:@"Map_SearchBarColor"];
            searchBar.textColor = [UIColor colorNamed:@"Map_TextColor"];
        } else {
            searchBar.backgroundColor = [UIColor colorWithHexString:@"#F0F4FD"];
            searchBar.textColor = [UIColor colorWithHexString:@"#15305B"];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.trailing.equalTo(self);
        make.bottom.equalTo(self.hotScrollView);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(STATUSBARHEIGHT + 15);
        make.leading.equalTo(self).offset(15);
        make.height.equalTo(@19);
        make.width.equalTo(@9);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backButton.mas_trailing).offset(20);
        make.centerY.equalTo(self.backButton);
        make.trailing.equalTo(self).offset(-15);
        make.height.equalTo(@32);
    }];
    self.searchBar.layer.cornerRadius = 16;
    
    [self.searchScopeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.searchBar).offset(12);
        make.centerY.equalTo(self.searchBar);
        make.height.width.equalTo(@15);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.searchBar).offset(-16);
        make.centerY.equalTo(self.searchBar);
        make.height.width.equalTo(@10);
    }];
    
    [self.starButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotScrollView);
        make.height.equalTo(@54);
        make.width.equalTo(@75);
        make.trailing.equalTo(self);
    }];
    
    for (int i = 0; i < self.hotButtonArray.count; i++) {
        if (i == 0) {
            [self.hotButtonArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.top.bottom.equalTo(self.hotScrollView);
                make.width.equalTo(@(self.hotButtonArray[i].buttonWidth + 28));
            }];
        } else if (i == self.hotButtonArray.count - 1) {
            [self.hotButtonArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.hotButtonArray[i - 1].mas_trailing);
                make.top.bottom.trailing.equalTo(self.hotScrollView);
                make.width.equalTo(@(self.hotButtonArray[i].buttonWidth + 28));
            }];
        } else {
            [self.hotButtonArray[i] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.hotButtonArray[i - 1].mas_trailing);
                make.top.bottom.equalTo(self.hotScrollView);
                make.width.equalTo(@(self.hotButtonArray[i].buttonWidth + 28));
            }];
        }
    }
    
    [self.hotScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self.starButton.mas_leading);
        make.top.equalTo(self.searchBar.mas_bottom).offset(6);
        make.height.equalTo(@54);
    }];
    
    [self.mapScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.hotScrollView.mas_bottom);
    }];
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(MAIN_SCREEN_W));
        make.height.equalTo(@(self.mapDataItem.mapHeight / self.mapDataItem.mapWidth * MAIN_SCREEN_W));
        make.top.leading.trailing.bottom.equalTo(self.mapScrollView);
    }];
}

- (void)back {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}


# pragma mark - TextField代理
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    self.cancelButton.hidden = NO;
    
    if (self.beforeSearchView) {
        return;
    }
    
    CGFloat beforeSearchViewY = CGRectGetMaxY(self.searchBar.frame);
    
    CQUPTMapSearchView *beforeSearchView = [[CQUPTMapSearchView alloc] initWithFrame:CGRectMake(0, beforeSearchViewY + 100, MAIN_SCREEN_W, MAIN_SCREEN_H - beforeSearchViewY)];
    beforeSearchView.alpha = 0;
    [self addSubview:beforeSearchView];
    self.beforeSearchView = beforeSearchView;
    
    
    [UIView animateWithDuration:0.32 animations:^{
        
        beforeSearchView.frame = CGRectMake(0, beforeSearchViewY, MAIN_SCREEN_W, MAIN_SCREEN_H - beforeSearchViewY);
        beforeSearchView.alpha = 1;
        
    } completion:nil];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    textField.text = @"";
    self.cancelButton.hidden = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0 && range.length == textField.text.length) {
        [UIView animateWithDuration:0.3 animations:^{
            self.beforeSearchView.resultTableView.alpha = 0;
            self.beforeSearchView.historyTableView.alpha = 1;
        }];
    }
    
    if ([string isEqualToString:@"\n"]) {
        if ([textField.text isEqualToString:@""]) {
            textField.text = self.mapDataItem.hotWord;
        }
        if ([self.delegate respondsToSelector:@selector(searchPlaceWithString:)]) {
            [self.delegate searchPlaceWithString:textField.text];
        }
    }
    
    return YES;
}

- (void)searchPlaceSuccess:(NSArray<CQUPTMapSearchItem *> *)placeIDArray {
    [self.beforeSearchView searchPlaceSuccess:placeIDArray];
}


# pragma mark - ScrollView代理
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.mapView;
}


#pragma mark - TableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.starPlaceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"d"];
    cell.textLabel.text = self.starPlaceArray[indexPath.row].placeNickname;
    cell.textLabel.font = [UIFont fontWithName:PingFangSCMedium size:15];
    if (@available(iOS 11.0, *)) {
        cell.textLabel.textColor = [UIColor colorNamed:@"Map_TextColor"];
    } else {
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#152F5B"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - TableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


# pragma mark - 手势
- (void)mapTapped:(UITapGestureRecognizer *)sender {
    CGPoint tapPoint = [sender locationInView:sender.view];
    
    for (CQUPTMapPlaceItem *place in self.mapDataItem.placeList) {
        for (CQUPTMapPlaceRect *rect in place.buildingList) {
            if ([rect isIncludePercentagePoint:tapPoint] || [place.tagRect isIncludePercentagePoint:tapPoint]) {
                NSLog(@"%@", place.placeName);
                [self selectedAPlace:place];
                // 请求详情数据
                if ([self.delegate respondsToSelector:@selector(requestPlaceDataWithPlaceID:)]) {
                    [self.delegate requestPlaceDataWithPlaceID:place.placeId];
                }

            }
        }
    }
}

- (void)placeDetailDataRequestSuccess:(CQUPTMapPlaceDetailItem *)placeDetailItem {
    [self.detailView loadDataWithPlaceDetailItem:placeDetailItem];
}


/// 点击了地图上某个地点后。上面那个方法判断成功后调用的。
- (void)selectedAPlace:(CQUPTMapPlaceItem *)placeItem {
    [UIView animateWithDuration:0.3 animations:^{
        self.detailView.alpha = 0;
        self.detailView.layer.affineTransform = CGAffineTransformScale(self.detailView.layer.affineTransform, 0.2, 0.2);
    }];
    
    CQUPTMapDetailView *detailView = [[CQUPTMapDetailView alloc] initWithPlaceItem:placeItem];
    [self addSubview:detailView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(transitionViewDragged:)];
    [detailView addGestureRecognizer:pan];
    
    [detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom);
        make.leading.width.equalTo(self);
        make.height.equalTo(@(MAIN_SCREEN_H));      // 让detailView足够高，不然上滑会滑过头
    }];
    
    [self layoutIfNeeded];
    
    CQUPTMapDetailView *lastDetailView = self.detailView;
    self.detailView = detailView;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        detailView.layer.affineTransform = CGAffineTransformTranslate(detailView.layer.affineTransform, 0, -112);
    } completion:^(BOOL finished) {
        [lastDetailView removeFromSuperview];
        [self layoutIfNeeded];
    }];
}

- (void)transitionViewDragged:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self];
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.lastY = sender.view.mj_y;
        
        if (sender.view.frame.origin.y < STATUSBARHEIGHT + 181 && translation.y < 0) { // 到顶后继续上拉要减速
            translation.y = translation.y / (MAIN_SCREEN_H / sender.view.mj_y);
        }
                
        sender.view.center = CGPointMake(sender.view.center.x, sender.view.center.y + translation.y);
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
        // 超出范围后回弹
        if (sender.view.frame.origin.y < STATUSBARHEIGHT + 181) {       // 弹回到顶
            [UIView animateWithDuration:0.2 animations:^{
                sender.view.frame = CGRectMake(0, STATUSBARHEIGHT + 181, sender.view.width, sender.view.height);
            }];
            return;
        } else if (sender.view.frame.origin.y > MAIN_SCREEN_H - 112) {  // 弹回到底
            [UIView animateWithDuration:0.1 animations:^{
                sender.view.frame = CGRectMake(0, MAIN_SCREEN_H, sender.view.width, sender.view.height);
            } completion:^(BOOL finished) {
                [self.detailView removeFromSuperview];
                self.detailView = nil;
            }];
            return;
        }
        
        // 速度和距离判断，如果速度或距离大于某个值，完全弹出或归位
        if (sender.view.mj_y - self.lastY < 0) {        // 往上拉
            if ((MAIN_SCREEN_H - 112) - sender.view.mj_y > 100 || sender.view.mj_y - self.lastY < -10) {    // 移动距离 > 50 或者速度足够快
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    sender.view.frame = CGRectMake(0, STATUSBARHEIGHT + 181, sender.view.width, sender.view.height);
                } completion:nil];
            } else {        // 移动距离太小，弹回到底
                [UIView animateWithDuration:0.2 animations:^{
                    sender.view.frame = CGRectMake(0, MAIN_SCREEN_H - 112, sender.view.width, sender.view.height);
                }];
            }
        } else {                        // 往下拉
            if ((STATUSBARHEIGHT + 181) - sender.view.mj_y < -100 || sender.view.mj_y - self.lastY > 10) {    // 移动距离 > 50 或者速度足够快
                [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    sender.view.frame = CGRectMake(0, MAIN_SCREEN_H - 112, sender.view.width, sender.view.height);
                } completion:nil];
            } else {
                [UIView animateWithDuration:0.2 animations:^{
                    sender.view.frame = CGRectMake(0, STATUSBARHEIGHT + 181, sender.view.width, sender.view.height);
                }];
            }
        }
    }
    
    [sender setTranslation:CGPointZero inView:self];
}


#pragma mark - Button
- (void)clearSearchBar {
    
}

- (void)starButtonClicked {
    if (self.starDialogueBoxImageView) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.starDialogueBoxImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.starDialogueBoxImageView removeFromSuperview];
        }];
        
        return;
    }
    
    // 先请求数据
    if ([self.delegate respondsToSelector:@selector(requestStarData)]) {
        [self.delegate requestStarData];
    }
    
    // 对话框图片
    UIImage *dialogueImage = [UIImage imageNamed:@"Map_StarDialogueBox"];
    UIEdgeInsets edge = UIEdgeInsetsMake(30, 0, 20, 0);
    dialogueImage = [dialogueImage resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    
    CGFloat dialogueBoxY = CGRectGetMaxY(self.starButton.frame);
    UIImageView *dialogueImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MAIN_SCREEN_W - 15 - 135, dialogueBoxY, 135, 152)];
    dialogueImageView.image = dialogueImage;
    dialogueImageView.alpha = 0;
    dialogueImageView.userInteractionEnabled = YES;
    
    // 展示列表的tableView
    CGFloat tableWidth = dialogueImageView.bounds.size.width - 12;
    CGFloat tableHeight = dialogueImageView.bounds.size.height - 30;
    UITableView *starTableView = [[UITableView alloc] initWithFrame:CGRectMake(6, 10, tableWidth, tableHeight) style:UITableViewStylePlain];
    starTableView.rowHeight = 39;
    starTableView.dataSource = self;
    starTableView.delegate = self;
    starTableView.alpha = 0;        // 先隐藏tableView，数据加载完成后显示，加载完成回调就是后面一个方法
    UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
    starTableView.tableFooterView = footer;         // 用来隐藏多余的分割线
    self.starTableView = starTableView;
    [dialogueImageView addSubview:starTableView];
    
    [UIView animateWithDuration:0.3 animations:^{
        dialogueImageView.alpha = 1;
    }];
    
    [self addSubview:dialogueImageView];
    self.starDialogueBoxImageView = dialogueImageView;
}

- (void)starPlaceListRequestSuccess:(NSArray<CQUPTMapStarPlaceItem *> *)starPlaceArray {
    self.starPlaceArray = starPlaceArray;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (starPlaceArray.count <= 6) {
            CGFloat dialogueBoxY = CGRectGetMaxY(self.starButton.frame);
            self.starDialogueBoxImageView.frame = CGRectMake(MAIN_SCREEN_W - 15 - 135, dialogueBoxY, 135, starPlaceArray.count * 39 + 20);
        } else {
            CGFloat dialogueBoxY = CGRectGetMaxY(self.starButton.frame);
            self.starDialogueBoxImageView.frame = CGRectMake(MAIN_SCREEN_W - 15 - 135, dialogueBoxY, 135, 6 * 39 + 20);
        }
        
        CGFloat tableWidth = self.starDialogueBoxImageView.bounds.size.width - 12;
        CGFloat tableHeight = self.starDialogueBoxImageView.bounds.size.height - 9;
        self.starTableView.frame = CGRectMake(6, 9, tableWidth, tableHeight);
        
        self.starTableView.alpha = 1;
        
        if (starPlaceArray.count == 0) {
            CGFloat dialogueBoxY = CGRectGetMaxY(self.starButton.frame);
            self.starDialogueBoxImageView.frame = CGRectMake(MAIN_SCREEN_W - 15 - 135, dialogueBoxY, 135, 52);
            
            UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 135, 37)];
            noDataLabel.center = CGPointMake(self.starDialogueBoxImageView.width * 0.5, self.starDialogueBoxImageView.height * 0.5 + 4.5);
            noDataLabel.text = @"暂无收藏哦";
            noDataLabel.font = [UIFont fontWithName:PingFangSCMedium size:15];
            noDataLabel.textAlignment = NSTextAlignmentCenter;
            if (@available(iOS 11.0, *)) {
                noDataLabel.textColor = [UIColor colorNamed:@"Map_TextColor"];
            } else {
                noDataLabel.textColor = [UIColor colorWithHexString:@"#152F5B"];
            }
            
            [self.starDialogueBoxImageView addSubview:noDataLabel];
        }
        
    } completion:nil];
    
    [self.starTableView reloadData];
}


- (void)cancelSearch {
    [UIView animateWithDuration:0.3 animations:^{
        
        CGFloat beforeSearchViewY = CGRectGetMaxY(self.searchBar.frame);
        self.beforeSearchView.frame = CGRectMake(0, beforeSearchViewY + 100, MAIN_SCREEN_W, MAIN_SCREEN_H - beforeSearchViewY);
        self.beforeSearchView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.beforeSearchView removeFromSuperview];
    }];
}

@end
