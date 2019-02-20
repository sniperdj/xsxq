//
//  XSHomeController.m
//  FixBridge
//
//  Created by admin on 2019/2/20.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "XSHomeController.h"
#import <Masonry/Masonry.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "XSVoiceRecManager.h"
#import "XSHomeVm.h"

#define a 44
#define myRec [XSVoiceRecManager shareVoiceRec]

@interface XSHomeController ()

@property(nonatomic, strong)UIImageView *voiceImgView;

@property(nonatomic, strong)UITextView *recTextView;

@property(nonatomic, strong)UILabel *resultLabel;

@property(nonatomic, strong)UIButton *sendBtn;

@property(nonatomic, strong)XSHomeVm *homeVM;

@end

@implementation XSHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];

    [self setupUI];
    [self setupEvent];
}

- (void)setupUI {
    self.voiceImgView = [[UIImageView alloc] init];
    [self.view addSubview:self.voiceImgView];
    [self.voiceImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.height.mas_equalTo(80);
        make.bottom.mas_equalTo(self.view).mas_offset(-120);
    }];
    self.voiceImgView.backgroundColor = [UIColor cyanColor];
    self.voiceImgView.userInteractionEnabled = YES;
    //    self.voiceImgView.hidden = YES;
    
    self.recTextView = [[UITextView alloc] init];
    [self.view addSubview:self.recTextView];
    [self.recTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(200);
    }];
    
    self.resultLabel = [[UILabel alloc] init];
    [self.view addSubview:self.resultLabel];
    [self.resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.recTextView);
        make.top.mas_equalTo(self.recTextView.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    
}

- (void)setupEvent {
    UILongPressGestureRecognizer *longprs = [[UILongPressGestureRecognizer alloc] init];
    __weak typeof(self)weakSelf = self;
    [[longprs rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        if (![x isKindOfClass:[UILongPressGestureRecognizer class]]) {
            weakSelf.recTextView.text = @"异常 -- 不是长按";
            return ;
        }
        UILongPressGestureRecognizer *longtap = (UILongPressGestureRecognizer *)x;
        if (UIGestureRecognizerStateBegan == longtap.state) { // 开始长按
            NSLog(@"start long press");
            weakSelf.recTextView.text = @"";
            [myRec startRecWithResultBlock:^(NSString * _Nonnull recString) {
                NSLog(@"识别成功 : %@", recString);
                weakSelf.recTextView.text = recString;
            }];
            
        } else if (UIGestureRecognizerStateEnded == longtap.state) { // 结束长按
            NSLog(@"end long press");
            [myRec stopRec];
        }
    }];
    [self.voiceImgView addGestureRecognizer:longprs];
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
