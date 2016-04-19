//
//  InterestScrollerView.m
//  BYDailyNews
//
//  Created by 财通网络 on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "InterestScrollView.h"
#import "InterestListItem.h"
#import "Masonry.h"
@interface InterestScrollView()

@property (nonatomic, strong) UIView *headeroneview;

@property (nonatomic, strong) UIView *headertwoview;

@property (nonatomic,strong) NSMutableArray *allItemsarray;

@property (nonatomic,strong) InterestListItem *itemSelect;

@end

@implementation InterestScrollView

- (void)setListAllArray:(NSMutableArray *)listAllArray
{
    _listAllArray = listAllArray;
    self.showsVerticalScrollIndicator = NO;
    self.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    self.backgroundColor = [UIColor whiteColor];
    NSArray *listTop = listAllArray[0];
    NSArray *listBottom = listAllArray[1];
    
#pragma 标签
    
    __weak typeof(self)weekSelf = self;
    
    self.headeroneview = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, self.frame.size.width, 40))];
    [self addSubview:self.headeroneview];
    
    UILabel *myclasstitlelabel = [[UILabel alloc]init];
    myclasstitlelabel.text = @"我的分类";
    myclasstitlelabel.font = [UIFont systemFontOfSize:16];
    [self.headeroneview addSubview:myclasstitlelabel];
    [myclasstitlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weekSelf.headeroneview.mas_top).offset(12);
        make.left.mas_equalTo(weekSelf.headeroneview.mas_left).offset(20);
    }];
    self.myclassLab = myclasstitlelabel;
    
    UILabel *detaillabel = [[UILabel alloc]init];
    detaillabel.text = @"长按可拖动排序删除。";
    detaillabel.textColor = [UIColor grayColor];
    detaillabel.font = [UIFont systemFontOfSize:11];
    [self.headeroneview addSubview:detaillabel];
    [detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weekSelf.myclassLab.mas_top).offset(3);
        make.left.mas_equalTo(weekSelf.myclassLab.mas_right).offset(5);
    }];
    self.detailLab = detaillabel;

    UIButton *editbutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [editbutton setTitle:@"编辑" forState:(UIControlStateNormal)];
    [editbutton addTarget:self action:@selector(sortBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    [editbutton setFont:[UIFont systemFontOfSize:12]];
    editbutton.layer.borderWidth = 1;
    editbutton.layer.cornerRadius = 5;
    editbutton.layer.borderColor = [[UIColor grayColor] CGColor];
    [editbutton setTitleColor:[UIColor grayColor] forState:0];
    [self.headeroneview addSubview:editbutton];
    [editbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weekSelf.headeroneview.mas_top).offset(12);
        make.right.mas_equalTo(weekSelf.headeroneview.mas_right).offset(-20);
    }];
    self.editBtn = editbutton;
        
    /**  点击添加频道按钮底部的view*/
    self.headertwoview = [[UIView alloc] initWithFrame:CGRectMake(0,self.headeroneview.frame.size.height/*加上高度*/ + padding+(padding + kItemH)*((listTop.count -1)/itemPerLine+1),kScreenW, 30)];
    self.headertwoview.backgroundColor = RGBColor(238.0, 238.0, 238.0);
    [self addSubview:self.headertwoview];
    
    UILabel *recommendedclasslabel = [[UILabel alloc]init];
    recommendedclasslabel.text = @"分类推荐";
    recommendedclasslabel.font = [UIFont systemFontOfSize:16];
    [self.headertwoview addSubview:recommendedclasslabel];
    [recommendedclasslabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weekSelf.headertwoview.mas_top).offset(5);
        make.left.mas_equalTo(weekSelf.headertwoview.mas_left).offset(20);
    }];
    self.recommendedclassLab = recommendedclasslabel;
    
        NSInteger count1 = listTop.count; // listTop  我的频道数组
        for (int i =0; i <count1; i++) {
            
            // **********************   控制按钮的frame值  **********************
            InterestListItem *item = [[InterestListItem alloc] initWithFrame:CGRectMake(padding+(padding+kItemW)*(i% itemPerLine), padding+(kItemH + padding)*(i/itemPerLine) + self.headeroneview.frame.size.height, kItemW, kItemH)];
            item.longPressBlock = ^(){
                if (weekSelf.longPressedBlock) {
                    weekSelf.longPressedBlock();
                }
            };

            item.itemName = listTop[i];
            item.location = top;
            [self.toparrayView addObject:item];
            item->locateView = self.toparrayView;
            item->topView = self.toparrayView;
            item->bottomView = self.bottomarrayView;
            item.hitTextLabel = self.headertwoview;
            [self addSubview:item];
            [self.allItemsarray addObject:item];
            
            if (!self.itemSelect) {
                [item setTitleColor:[UIColor redColor] forState:0];
                self.itemSelect = item;
            }
        }
        
        NSInteger count2 = listBottom.count;
        for (int i=0; i<count2; i++) {
            InterestListItem *item = [[InterestListItem alloc] initWithFrame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine),CGRectGetMaxY(self.headertwoview.frame)+padding+(kItemH+padding)*(i/itemPerLine), kItemW, kItemH)];
            item.longPressBlock = ^(){
                if (weekSelf.longPressedBlock) {
                    weekSelf.longPressedBlock();
                }
            };

            item.itemName = listBottom[i];
            item.location = bottom;
            item.hitTextLabel = self.headertwoview;
            [self.bottomarrayView addObject:item];
            item->locateView = self.bottomarrayView;
            item->topView = self.toparrayView;
            item->bottomView = self.bottomarrayView;
            [self addSubview:item];
            [self.allItemsarray addObject:item];
        }
        self.contentSize = CGSizeMake(kScreenW, CGRectGetMaxY(self.headertwoview.frame)+padding+(kItemH+padding)*((count2-1)/4+1) + 50);//加 50 可以使按钮现实完整
}

-(void)itemRespondFromListBarClickWithItemName:(NSString *)itemName{
    for (int i = 0 ; i<self.allItemsarray.count; i++) {
        InterestListItem *item = (InterestListItem *)self.allItemsarray[i];
        if ([itemName isEqualToString:item.itemName]) {
            [self.itemSelect setTitleColor:RGBColor(111.0, 111.0, 111.0) forState:0];
            [item setTitleColor:[UIColor redColor] forState:0];
            self.itemSelect = item;
        }
    }
}


-(void)sortBtnClick:(UIButton *)sender{
    if (sender.selected) {
        [sender setTitle:@"编辑" forState:0];
    }
    else{
        [sender setTitle:@"完成" forState:0];
    }
    sender.selected = !sender.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sortBtnClick"
                                                        object:sender
                                                      userInfo:nil];
}


-(NSMutableArray *)allarrayItems{
    if (_allItemsarray == nil) {
        _allItemsarray = [NSMutableArray array];
    }
    return _allItemsarray;
}

-(NSMutableArray *)toparrayView{
    if (_toparrayView == nil) {
        _toparrayView = [NSMutableArray array];
    }
    return _toparrayView;
}

-(NSMutableArray *)bottomarrayView{
    if (_bottomarrayView == nil) {
        _bottomarrayView = [NSMutableArray array];
    }
    return _bottomarrayView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
