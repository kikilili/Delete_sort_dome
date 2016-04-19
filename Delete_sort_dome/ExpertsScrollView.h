//
//  ExpertsScrollView.h
//  BYDailyNews
//
//  Created by 财通网络 on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertsScrollView : UIScrollView

@property (nonatomic,strong) NSMutableArray *toparrayView;
@property (nonatomic,strong) NSMutableArray *bottomarrayView;
@property (nonatomic,strong) NSMutableArray *listAllArray;

@property (nonatomic,copy) void(^longPressedBlock)();
//元素
@property (nonatomic, strong) UILabel *myclassLab;
@property (nonatomic, strong) UILabel *detailLab;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, strong) UILabel *recommendedclassLab;
@property (nonatomic, strong) UIButton *rianglebutton;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) NSString *itemName;//

-(void)sortBtnClick:(UIButton *)sender;

@end
