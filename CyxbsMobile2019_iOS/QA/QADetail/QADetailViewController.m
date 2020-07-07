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
#import "QADetailView.h"
#import "QADetailReportView.h"
#import "GKPhotoBrowser.h"
#import "QAReviewViewController.h"
@interface QADetailViewController ()<QADetailDelegate>
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)NSNumber *question_id;
@property(strong,nonatomic)QADetailModel *model;
//举报界面
@property(strong,nonatomic)SDMask *reportViewMask;
@property(strong,nonatomic)QADetailReportView *reportView;
@end

@implementation QADetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F8F9FC"];
    
}

- (void)customNavigationRightButton{
    [self.rightButton setImage:[UIImage imageNamed:@"QAMoreButton"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(showReportView) forControlEvents:UIControlEventTouchUpInside];
}

-(instancetype)initViewWithId:(NSNumber *)question_id title:(NSString *)title{
    self = [super init];
    self.title = title;
//    [self setNavigationBar:title];
    self.question_id = question_id;
    self.model = [[QADetailModel alloc]init];
    [self setNotification];
    
    [self loadData];
    return self;
}

- (void)setupUI{
    //    NSLog(@"%@",self.model.dataDic);
    NSDictionary *detailData = self.model.detailData;
    NSArray *answersData = self.model.answersData;
    QADetailView *detailView = [[QADetailView alloc]initWithFrame:CGRectMake(0, TOTAL_TOP_HEIGHT, SCREEN_WIDTH, self.view.height - TOTAL_TOP_HEIGHT)];
    
    [detailView setupUIwithDic:detailData answersData:answersData];
    [detailView.answerButton setTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    detailView.delegate = self;
    [self.view addSubview:detailView];
}
- (void)loadData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载数据中...";
    hud.color = [UIColor colorWithWhite:0.f alpha:0.4f];
    [self.model getDataWithId:self.question_id];
}
- (void)setNotification{
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

- (void)QADetailDataLoadSuccess{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setupUI];
    //    NSLog(@"%D,%@",self.model.dataArray.count, self.model.dataArray[0]);
}
- (void)QADetailDataLoadError{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"数据加载错误" message:@"网络数据解析错误" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

- (void)QADetailDataLoadFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"数据加载失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [controller addAction:act1];
    
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}
- (void)reloadView{
    [self.view removeAllSubviews];
    [self customNavigationBar];
    [self customNavigationRightButton];
    [self loadData];
}
- (void)showReportView{
    
    self.reportView = [[QADetailReportView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 530)];
    [self.reportView setBackgroundColor:UIColor.clearColor];
    [self.reportView setupView];
    for (UIButton *btn in self.reportView.reportBtnCollection) {
        if (btn.tag == 5){
             [btn addTarget:self action:@selector(ignore:) forControlEvents:UIControlEventTouchUpInside];
        }else{
        [btn addTarget:self action:@selector(report:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    [self.reportView.cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    self.reportViewMask = [[SDMaskUserView(self.reportView) sdm_showActionSheetIn:self.view usingBlock:nil] usingAutoDismiss];
        [self.reportViewMask show];
}
//举报问题
- (void)report:(UIButton *)sender{
    [self.model report:sender.titleLabel.text question_id:self.question_id];
//    NSLog(@"%@,%lD",sender.titleLabel.text,(long)sender.tag);
}
//忽略问题
- (void)ignore:(UIButton *)sender{
    [self.model ignore:self.question_id];
//    NSLog(@"%@,%lD",sender.titleLabel.text,(long)sender.tag);
}
- (void)cancel:(UIButton *)sender{
    [self.reportViewMask dismiss];
//    NSLog(@"%@,%lD",sender.titleLabel.text,(long)sender.tag);
}

- (void)answer:(UIButton *)sender{
    QAAnswerViewController *vc = [[QAAnswerViewController alloc]initWithQuestionId:self.question_id content:[self.model.detailData objectForKey:@"title"]];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)replyComment:(nonnull NSNumber *)answerId {
}

- (void)tapCommentBtn:(nonnull NSNumber *)answerId {
    [self.model getCommentData:answerId];
}

- (void)tapPraiseBtn:(UIButton *)pariseBtn answerId:(nonnull NSNumber *)answerId{
    if ([pariseBtn isSelected]) {
        [self.model cancelPraise:answerId];
    }else{
        [self.model praise:answerId];
    }
}
- (void)tapAdoptBtn:(nonnull NSNumber *)answerId{
    [self.model adoptAnswer:self.question_id answerId:answerId];
}
- (void)tapToViewBigImage:(NSInteger)answerIndex{
    for (NSDictionary *answerData in self.model.answersData) {
        if ([[answerData objectForKey:@"id"] integerValue] == answerIndex){
            
            NSArray *imageUrls = [answerData objectForKey:@"photo_url"];
            NSMutableArray *photos = [NSMutableArray array];
            for (int i = 0; i < imageUrls.count; i++) {
                GKPhoto *photo = [GKPhoto new];
                photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imageUrls[i]]];
                [photos addObject:photo];
            }
            GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:0];
            browser.showStyle = GKPhotoBrowserShowStyleNone;
            [browser showFromVC:self];
            
        }
    }
}

- (void)tapToViewComment:(NSNumber *)answerId{
    for(int i = 0; i < self.model.answersData.count; i++){
        NSDictionary *dic = self.model.answersData[i];
        if ([answerId integerValue] == [[dic objectForKey:@"id"] integerValue]) {
            QAReviewViewController *vc = [[QAReviewViewController alloc]initViewWithId:answerId answerData:dic];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
    
    
}
@end
