//
//  MainViewController.m
//  Delete_sort_dome
//
//  Created by 财通网络 on 16/3/23.
//  Copyright © 2016年 财通网络. All rights reserved.
//

#import "MainViewController.h"
#import "InterestScrollView.h"
#import "ExpertsScrollView.h"
#import "Masonry.h"
#import "JumpViewController.h"
@interface MainViewController ()

@property (nonatomic, strong) UIView *navBarView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *bottomNextBtn;
@property (nonatomic, strong) UIButton *bottomCompleteBtn;

@property (nonatomic,strong) InterestScrollView *interestSV;
@property (nonatomic, strong) ExpertsScrollView *expertsSV;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"拖拽感兴趣的类别到我的分类";
    
    [self makeContent];

}

-(void)makeContent
{
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:(UIBarButtonItemStylePlain) target:nil action:nil];
    
    NSMutableArray *listTop = [[NSMutableArray alloc] initWithArray:@[@"社会",@"娱乐",@"科技",@"汽车",@"体育",@"订阅"]];
    NSMutableArray *listBottom = [[NSMutableArray alloc] initWithArray:@[@"电影",@"数码",@"育儿",@"美食",@"政务",@"数码",@"育儿",@"数码",@"育儿"]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(Foreigncurrency)
                                                 name:@"Foreigncurrency"
                                               object:nil];
    
    UIButton *bottomnextbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [bottomnextbutton setTitle:@"下一步" forState:(UIControlStateNormal)];
    bottomnextbutton.backgroundColor = [UIColor grayColor];
    [bottomnextbutton addTarget:self action:@selector(bottomBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:bottomnextbutton];
    [bottomnextbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    self.bottomNextBtn = bottomnextbutton;
    
    __weak typeof(self) unself = self;
    
    
    if (!self.interestSV) {
        self.interestSV = [[InterestScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 100)];
        self.interestSV.listAllArray = [NSMutableArray arrayWithObjects:listTop,listBottom, nil];
        self.interestSV.longPressedBlock = ^(){
            [unself.interestSV sortBtnClick:unself.interestSV.editBtn];
        };
        
        [self.view addSubview:self.interestSV];
    }
    
    //
    self.expertsSV = [[ExpertsScrollView alloc]initWithFrame:(CGRectMake(kScreenW, 64, kScreenW, kScreenH -100))];
    self.expertsSV.backgroundColor = [UIColor grayColor];
    self.expertsSV = [[ExpertsScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH - 100)];
    self.expertsSV.listAllArray = [NSMutableArray arrayWithObjects:listBottom,listTop, nil];
    self.expertsSV.longPressedBlock = ^(){
        [unself.expertsSV sortBtnClick:unself.expertsSV.editBtn];
    };
}

- (void)bottomBtnClick
{
    NSLog(@">>>下一步");
    [self.view addSubview:self.expertsSV];
    [UIView animateWithDuration:1.0f animations:^{
        self.expertsSV.frame = CGRectMake(0, 64, kScreenW, kScreenH - 100);
        self.title = @"拖拽感兴趣的专家到我的专家";
        [self.bottomNextBtn removeFromSuperview];
        UIButton *bottomcompletebutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [bottomcompletebutton setTitle:@"完成" forState:(UIControlStateNormal)];
        bottomcompletebutton.backgroundColor = [UIColor grayColor];
        [bottomcompletebutton addTarget:self action:@selector(bottomCompleteBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        [self.view addSubview:bottomcompletebutton];
        [bottomcompletebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.view.mas_bottom);
            make.centerX.mas_equalTo(self.view.mas_centerX);
        }];
        self.bottomCompleteBtn = bottomcompletebutton;
    }];
}

- (void)bottomCompleteBtnClick
{
    NSLog(@"完成");
}

- (void)Foreigncurrency
{
    JumpViewController *jumpVC = [[JumpViewController alloc]init];
    [self.navigationController pushViewController:jumpVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
