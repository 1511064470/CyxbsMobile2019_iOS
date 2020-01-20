//
//  IntegralStoreViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/1/16.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "IntegralStoreViewController.h"
#import "CheckInViewController.h"
#import "IntegralStorePresenter.h"
#import "IntegralStorePresenterProtocol.h"
#import "IntegralStoreDataItem.h"
#import "IntegralStoreCell.h"


static NSString *const ItemID = @"ItemID";


@interface IntegralStoreViewController () <IntegralStoreContentViewDelegate, IntegralStorePresenterProtocol, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, copy) NSArray<IntegralStoreDataItem *> *dataItemArray;
@property (nonatomic, weak) MBProgressHUD *loadingHUD;

@end

@implementation IntegralStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.presenter = [[IntegralStorePresenter alloc] init];
    [self.presenter attachView:self];

    // 加载UI
    IntegralStoreContentView *contentView = [[IntegralStoreContentView alloc] init];
    contentView.delegate = self;
    [self.view addSubview:contentView];
    self.contentView = contentView;

    self.contentView.storeCollectionView.dataSource = self;
    self.contentView.storeCollectionView.delegate = self;
    [self.contentView.storeCollectionView registerClass:[IntegralStoreCell class] forCellWithReuseIdentifier:ItemID];

    // 加载数据
    [self.presenter loadStoreData];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"正在加载...";
    self.loadingHUD = hud;
}

- (void)dealloc
{
    [self.presenter dettachView];
}


- (void)dismissWithGesture:(UIPanGestureRecognizer *)gesture {
    ((CheckInViewController *)self.transitioningDelegate).presentPanGesture = gesture;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)storeDataLoadSucceeded:(id)responseObject {
    [self.loadingHUD hide:YES];
    
    self.dataItemArray = responseObject;
    [self.contentView.storeCollectionView reloadData];
}

- (void)storeDataLoadFailed {
    [self.loadingHUD hide:YES];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Σ（ﾟдﾟlll）加载失败了...";
    [hud hide:YES afterDelay:1];
}


#pragma mark - CollectionView数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataItemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IntegralStoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ItemID forIndexPath:indexPath];
    
    cell.item = self.dataItemArray[indexPath.item];
    
    return cell;
}


@end
