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

@interface CQUPTMapContentView () <UITextFieldDelegate>

// 数据
@property (nonatomic, strong) CQUPTMapDataItem *mapDataItem;
@property (nonatomic, copy) NSArray<CQUPTMapHotPlaceItem *> *hotPlaceItemArray;

// 控件
@property (nonatomic, weak) UIButton *backButton;
@property (nonatomic, weak) UITextField *searchBar;
@property (nonatomic, weak) UIImageView *searchScopeImageView;
@property (nonatomic, weak) UIButton *cancelButton;

@property (nonatomic, weak) UIScrollView *hotScrollView;
@property (nonatomic, strong) NSMutableArray<CQUPTMapHotPlaceButton *> *hotButtonArray;
@property (nonatomic, weak) CQUPTMapMyStarButton *starButton;

@property (nonatomic, weak) UIImageView *mapView;

@end


@implementation CQUPTMapContentView

- (instancetype)initWithFrame:(CGRect)frame andMapData:(CQUPTMapDataItem *)mapDataItem andHotPlaceItemArray:(nonnull NSArray<CQUPTMapHotPlaceItem *> *)hotPlaceItemArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.mapDataItem = mapDataItem;
        self.hotPlaceItemArray = hotPlaceItemArray;
        
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
        searchBar.font = [UIFont fontWithName:PingFangSCHeavy size:14];
        searchBar.placeholder = @"搜索地点";
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
        [self addSubview:starButton];
        self.starButton = starButton;
        
        
        // 地图
        UIImageView *mapView = [[UIImageView alloc] init];
        mapView.backgroundColor = [UIColor grayColor];
        mapView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
        [mapView addGestureRecognizer:tap];
        [self addSubview:mapView];
        self.mapView = mapView;
        
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
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(self);
        make.top.equalTo(self.hotScrollView.mas_bottom);
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.cancelButton.hidden = YES;
}


# pragma mark - 手势
- (void)mapTapped:(UITapGestureRecognizer *)sender {
    CGPoint tapPoint = [sender locationInView:sender.view];
    
    for (CQUPTMapPlaceItem *place in self.mapDataItem.placeList) {
        for (CQUPTMapPlaceRect *rect in place.buildingList) {
            if ([rect isIncludePercentagePoint:tapPoint]) {
                NSLog(@"yes");
            }
        }
    }
}


@end
