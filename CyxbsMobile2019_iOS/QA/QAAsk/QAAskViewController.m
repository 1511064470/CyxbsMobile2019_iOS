//
//  QAAskViewController.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/1/24.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAskViewController.h"
#import "QAAskModel.h"
#import "QAAskNextStepView.h"
#import "QAAskIntegralPickerView.h"
#import "QAExitView.h"
#import "GKPhotoBrowser.h"

@interface QAAskViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(assign,nonatomic)BOOL isFromDraft;
@property(strong,nonatomic)QAAskModel *model;
//提问标题
@property(strong,nonatomic)UITextField *titleTextField;
//提问内容
@property(strong,nonatomic)UITextView *askTextView;
//选择提问类型
@property(copy,nonatomic)NSString *kind;
@property(strong,nonatomic)NSMutableArray *kindBtnArray;
//添加图片
@property(strong,nonatomic)NSMutableArray<UIImage *> *askImageArray;
@property(strong,nonatomic)NSMutableArray<UIImageView *> *askImageViewArray;

//下一步提示界面
@property(strong,nonatomic)QAAskNextStepView *nextStepView;
@property(strong,nonatomic)SDMask *nextStepViewMask;

//退出提示界面
@property(strong,nonatomic)QAExitView *exitView;
@property(strong,nonatomic)SDMask *exitViewMask;
@end

@implementation QAAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.title = @"提问";
        if (@available(iOS 11.0, *)) {
            self.view.backgroundColor = [UIColor colorNamed:@"QABackgroundColor"];
        } else {
            self.view.backgroundColor = [UIColor whiteColor];
        }
        self.isFromDraft = NO;
        [self setNotification];
        self.model = [[QAAskModel alloc]init];
        [self setupUI];
    }
    return self;
}
- (instancetype)initFromDraft:(NSDictionary *)dic {
    if (self = [self init]) {
        self.titleTextField.text = [dic objectForKey:@"title"];
        self.askTextView.text = [dic objectForKey:@"description"];
        self.kind = [dic objectForKey:@"kind"];
        self.isFromDraft = YES;
        for (int i = 0; i < self.kindBtnArray.count; i++) {
            UIButton *btn = self.kindBtnArray[i];
            if ([btn.currentTitle isEqualToString:self.kind]) {
                [self tapTitleBtn:btn];
            }
        }
    }
    return self;
}
- (void)customNavigationRightButton{
    [self.rightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rightButton.superview).offset(STATUSBARHEIGHT);
        make.width.equalTo(@60);
        make.height.equalTo(@44);
    }];
    if (@available(iOS 11.0, *)) {
        [self.rightButton setTitleColor:[UIColor colorNamed:@"QANavigationTitleColor"] forState:UIControlStateNormal];;
    } else {
        [self.rightButton setTitleColor:[UIColor colorWithHexString:@"#15315B"] forState:UIControlStateNormal];
    }
    [self.rightButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
}
- (void)back {
    [self saveAskContent];
}

- (void)setNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAQuestionCommitSuccess)
                                                 name:@"QAQuestionCommitSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(QAQuestionCommitFailure)
                                                 name:@"QAQuestionCommitFailure" object:nil];
}
- (void)setupUI{
    UIView *titleView = [[UIView alloc]init];
    [self.view addSubview:titleView];
    [titleView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(TOTAL_TOP_HEIGHT + 20);
        make.height.mas_equalTo(25);
    }];
    NSArray *titleArray = @[@"学习",@"匿名",@"生活",@"其他"];
    //默认是选中学习类型
    self.kind = titleArray[0];
    self.kindBtnArray = [NSMutableArray array];
    for (int i = 0; i < titleArray.count; i++) {
        
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleBtn setTitle:titleArray[i] forState:UIControlStateNormal];
        if (@available(iOS 11.0, *)) {
            [titleBtn setTitleColor:[UIColor colorNamed:@"QAAskTagTextColor_Off"] forState:UIControlStateNormal];
        } else {
            [titleBtn setTitleColor:[UIColor colorWithHexString:@"#94A6C4"] forState:UIControlStateNormal];
        }
        [titleBtn.titleLabel setFont:[UIFont fontWithName:PingFangSCRegular size:13]];
        
        titleBtn.layer.cornerRadius = 12;
        titleBtn.tag = i;
        [titleBtn addTarget:self action:@selector(tapTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            [titleBtn setFrame:CGRectMake(20, 5, 50, 25)];
            if (@available(iOS 11.0, *)) {
                titleBtn.backgroundColor = [UIColor colorNamed:@"QAAskTagButtonColor_On"];
            } else {
                titleBtn.backgroundColor = [UIColor colorWithHexString:@"#F7DAD7"];
            }
        }else{
            [titleBtn setFrame:CGRectMake(20+i*65, 5, 50, 25)];
            if (@available(iOS 11.0, *)) {
                titleBtn.backgroundColor = [UIColor colorNamed:@"QAAskTagButtonColor_Off"];
            } else {
                titleBtn.backgroundColor = [UIColor colorWithHexString:@"#E8F0FC"];
            }
        }
        
        [self.kindBtnArray addObject:titleBtn];
        [titleView addSubview:titleBtn];
        
    }
    
    
    self.titleTextField = [[UITextField alloc]init];
    self.titleTextField.layer.cornerRadius = 8;
    //设置placeholder字体大小颜色
    NSString *placeholderString = @"输入标题";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:placeholderString];
    [placeholder addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:PingFangSCBold size:16]
                        range:NSMakeRange(0, placeholderString.length)];
    if (@available(iOS 11.0, *)) {
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorNamed:@"QANavigationTitleColor"]
                            range:NSMakeRange(0, placeholderString.length)];
    } else {
        [placeholder addAttribute:NSForegroundColorAttributeName
                            value:[UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1]
                            range:NSMakeRange(0, placeholderString.length)];
    }
    self.titleTextField.attributedPlaceholder = placeholder;
    //设置光标起始位置偏移
    self.titleTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.titleTextField.leftView.userInteractionEnabled = NO;
    self.titleTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.titleTextField];
    
    [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.top.mas_equalTo(titleView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(40);
    }];
    
    
    self.askTextView = [[UITextView alloc]init];
    self.askTextView.layer.cornerRadius = 8;
    [self.askTextView setTextColor:[UIColor colorWithHexString:@"#15315B"]];
    //自适应高度
    self.askTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.askTextView.placeholder = @"详细描述你的问题和需求，表达越清楚，越容易获得帮助哦！";
    self.askTextView.textContainerInset = UIEdgeInsetsMake(10, 12, 10, 12);
    [self.askTextView setFont:[UIFont fontWithName:PingFangSCRegular size:16]];
    self.askTextView.delegate = self;
    [self.view addSubview:self.askTextView];
    [self.askTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.top.mas_equalTo(self.titleTextField.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(215);
    }];
    
    
    // 深色模式适配
    if (@available(iOS 11.0, *)) {
        self.titleTextField.backgroundColor = [UIColor colorNamed:@"QATextViewColor"];
        self.askTextView.backgroundColor = [UIColor colorNamed:@"QATextViewColor"];
        self.askTextView.placeholderColor = [UIColor colorNamed:@"QATextViewPlaceholderColor"];
//        QAAskTagTextColor
    } else {
        self.titleTextField.backgroundColor = [UIColor colorWithHexString:@"#E8F0FC"];
        self.askTextView.backgroundColor = [UIColor colorWithHexString:@"#e8edfd"];
        self.askTextView.placeholderColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:0.39];
    }
    
    
    //    UIImageView *addImageView = [[UIImageView alloc]init];
    self.askImageArray = [NSMutableArray array];
    self.askImageViewArray = [NSMutableArray array];
    [self setAddImageView];

}
- (void)QAQuestionCommitSuccess{
    [self hiddenNextStepView];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)QAQuestionCommitFailure{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertController *controller=[UIAlertController alertControllerWithTitle:@"网络错误" message:@"答案提交失败" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *act1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:act1];
    [self presentViewController:controller animated:YES completion:nil];
}
//标题字数限制
- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *toBeString = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > 12) {
            textField.text = [toBeString substringToIndex:12];
        }
    }
    // 有高亮选择的字符串，则暂不对文字进行统计和限制
    else{
      
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)tapTitleBtn:(UIButton *)sender{
    
    for (int i = 0;i < self.kindBtnArray.count;i++) {
        UIButton *btn = self.kindBtnArray[i];
        if (i == sender.tag) {
            if (@available(iOS 11.0, *)) {
                btn.backgroundColor = [UIColor colorNamed:@"QAAskTagButtonColor_On"];
            } else {
                btn.backgroundColor = [UIColor colorWithHexString:@"#F7DAD7"];
            }
        }else{
            if (@available(iOS 11.0, *)) {
                btn.backgroundColor = [UIColor colorNamed:@"QAAskTagButtonColor_Off"];
            } else {
                btn.backgroundColor = [UIColor colorWithHexString:@"#E8F0FC"];
            }
        }
    }
    NSArray *titleArray = @[@"学习",@"匿名",@"生活",@"其他"];
    self.kind = titleArray[sender.tag];
}

- (void)setAddImageView{
    
    NSInteger count = self.askImageArray.count;
    // 只有小于等于6张图片的时候才添加”添加按钮“
    if (count + 1 <= 7) {
        
        UIImageView *addImageView = [[UIImageView alloc]init];
        [addImageView setImage:[UIImage imageNamed:@"addImageButton"]];
        addImageView.layer.cornerRadius = 8;
        addImageView.clipsToBounds = YES;
        addImageView.contentMode = UIViewContentModeScaleAspectFill;
        addImageView.userInteractionEnabled = YES;
        
        // 添加点击手势
        UIGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)];
        [addImageView addGestureRecognizer:tapGesture];
        [self.view addSubview:addImageView];
        
        NSInteger widthAndHeight = (SCREEN_WIDTH - 60)/3;
        
        // 如果“添加按钮”（其实是个图片）和其他图片总数小于7(0~5张图片)，那么将“添加按钮”加在其他图片后面。
        if (count + 1 < 7) {
            if (count < 3){
                [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * count);
                    make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(10);
                    make.height.width.mas_equalTo(widthAndHeight);
                }];
            } else {
                [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * (count - 3));
                    make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                    make.height.width.mas_equalTo(widthAndHeight);
                }];
            }
        } else if (count + 1 == 7) {        // 已经有6张图片了，“添加按钮”就不加在前面的图片后面了，而是直接加在第6张上面
            addImageView.alpha = 0.85;
            [addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * 2);
                make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                make.height.width.mas_equalTo(widthAndHeight);
            }];
        }
        [self.askImageViewArray addObject:addImageView];
    }
}
- (void)addImage{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;//编辑模式  但是编辑框是正方形的
    
    // 设置可用的媒体类型、默认只包含kUTTypeImage
    imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"从相机拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            //设置照片来源
            
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //        // 使用前置还是后置摄像头
            imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:photoAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}


- (void)changeImage:(UITapGestureRecognizer *)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *showBigImage = [UIAlertAction actionWithTitle:@"查看大图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSMutableArray *photos = [NSMutableArray array];
        NSInteger index = 0;
        
        for (int i = 0; i < self.askImageArray.count; i++) {
            UIImage *img = self.askImageArray[i];
            if (((UIImageView *)sender.view).image == img) {
                index = i;
            }
            GKPhoto *photo = [GKPhoto new];
            photo.image = img;
            [photos addObject:photo];
        }
        GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:index];
        browser.showStyle = GKPhotoBrowserShowStylePush;
        [browser showFromVC:self];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [actionSheet dismissViewControllerAnimated:YES completion:^{
            
            UIAlertController *warningAlertController = [UIAlertController alertControllerWithTitle:@"删除图片" message:@"确定要删除图片吗？" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *determineToDelete = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self.askImageArray removeObject:((UIImageView *)(sender.view)).image];
                NSLog(@"%@--%@", self.askImageArray, self.askImageViewArray);
                
                // 删除以后，图片需要往前移动。如果ImageArray还剩余6张及以上的图片，view不用移动，只需要将上面的image全部往前移动，else 是ImageView需要移动的情况
                if (self.askImageArray.count >= 6) {
                    for (int i = 0; i < 6; i++) {
                        self.askImageViewArray[i].image = self.askImageArray[i];
                    }
                } else {
                    [self.askImageViewArray removeObject:(UIImageView *)sender.view];
                    [sender.view removeFromSuperview];
                    // 删除图片以后全部重新约束
                    NSInteger widthAndHeight = (SCREEN_WIDTH - 60)/3;
                    for (int i = 0; i < self.askImageViewArray.count; i++) {
                        if (i < 3) {        // 前三个图片的约束
                            [self.askImageViewArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * i);
                                make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(10);
                                make.height.width.mas_equalTo(widthAndHeight);
                            }];
                        } else if (i < 6) { // 4, 5, 6的约束
                            [self.askImageViewArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * (i - 3));
                                make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                                make.height.width.mas_equalTo(widthAndHeight);
                            }];
                        } else if (i == self.askImageViewArray.count - 1) {  // 最后一个，是添加按钮。
                            [self.askImageViewArray[i] mas_remakeConstraints:^(MASConstraintMaker *make) {
                                make.left.mas_equalTo(self.view.mas_left).mas_offset(20 + (widthAndHeight + 10) * 2);
                                make.top.mas_equalTo(self.askTextView.mas_bottom).mas_offset(widthAndHeight + 20);
                                make.height.width.mas_equalTo(widthAndHeight);
                            }];
                        }
                        
                        [((UIView *)(self.askImageViewArray[i])) layoutIfNeeded];
                    }       // for 循环的后括号
                }       // else 的后括号
            }];     // ”确定删除图片“ alertAction 的后括号
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            
            [warningAlertController addAction:determineToDelete];
            [warningAlertController addAction:cancel];
            
            [self presentViewController:warningAlertController animated:YES completion:nil];
        }];  // dismiss alertSheet completion 的后括号
    }];  // ”删除图片“ alertAction 的后括号
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:showBigImage];
    [actionSheet addAction:deleteAction];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}



#pragma mark - =======UIImagePickerControllerDelegate=========

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.askImageArray addObject:image];
    if (self.askImageArray.count <= 6) {     // 第6张以后的图片都不显示在界面上，查看大图可以查看
        UIImageView *imgView = [self.askImageViewArray lastObject];
        [imgView setImage:image];
    
        // 在调用 “setAddImageView” 之前，将当前正在设置的 imageView 的手势方法改成查看大图，并且增加长按删除功能。
        [imgView removeGestureRecognizer:imgView.gestureRecognizers[0]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImage:)];
        [imgView addGestureRecognizer:tap];
        
        [self setAddImageView];
    }
    
}
// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)nextStep{
    [self.titleTextField resignFirstResponder];
    [self.askTextView resignFirstResponder];
    if (IS_IPHONEX) {
        self.nextStepView = [[QAAskNextStepView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 300)];
    }else{
        self.nextStepView = [[QAAskNextStepView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 160)];
    }
    
    self.nextStepView.backgroundColor = UIColor.redColor;
    [self.nextStepView.cancelBtn addTarget:self action:@selector(hiddenNextStepView) forControlEvents:UIControlEventTouchUpInside];
    [self.nextStepView.commitBtn addTarget:self action:@selector(commitAsk) forControlEvents:UIControlEventTouchUpInside];
    //    self.nextStepView.userInteractionEnabled = YES;
    self.nextStepViewMask = [[SDMaskUserView(self.nextStepView) sdm_showActionSheetIn:self.view usingBlock:nil] usingAutoDismiss];
    [self.nextStepViewMask show];
    
}
- (void)hiddenNextStepView{
    [self.nextStepViewMask dismiss];
}

- (void)commitAsk{
    NSString *title = self.titleTextField.text;
    NSString *content = self.askTextView.text;
    QAAskIntegralPickerView *integralPickerView =  self.nextStepView.integralPickView;
    NSString *reward = integralPickerView.integralNum;
    NSString *disappearTime = self.nextStepView.time;
    [self.model commitAsk:title content:content kind:self.kind reward:reward disappearTime:disappearTime imageArray:self.askImageArray];
    [self.nextStepViewMask dismiss];
    
}


- (void)saveAskContent{
    [self.titleTextField resignFirstResponder];
    [self.askTextView resignFirstResponder];
    if ([self.askTextView.text isEqualToString:@""]&&[self.titleTextField.text isEqualToString:@""]) {
        [self.exitView removeFromSuperview];
        [self.exitViewMask dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if (IS_IPHONEX) {
            self.exitView = [[QAExitView alloc]initWithFrame:CGRectMake(60,200, SCREEN_WIDTH - 120, 396)];
        }else{
            self.exitView = [[QAExitView alloc]initWithFrame:CGRectMake(60,120, SCREEN_WIDTH - 120, 396)];
        }
        
        [self.exitView.saveAndExitBtn addTarget:self action:@selector(saveAndExit) forControlEvents:UIControlEventTouchUpInside];
        [self.exitView.continueEditBtn addTarget:self action:@selector(continueEdit) forControlEvents:UIControlEventTouchUpInside];
        self.exitViewMask = [[SDMaskUserView(self.exitView) sdm_showAlertIn:self.view usingBlock:nil] usingAutoDismiss];
        [self.exitViewMask show];
    }
    
    
}
- (void)continueEdit{
    [self.exitViewMask dismiss];
}
- (void)saveAndExit{
    
    [self.exitView removeFromSuperview];
    [self.exitViewMask dismiss];
    NSString *title = self.titleTextField.text;
    NSString *content = self.askTextView.text;
    if (self.isFromDraft == NO) {
         [self.model addItemInDraft:title description:content kind:self.kind];
    }else{
         [self.model updateItemInDraft:title description:content kind:self.kind];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
