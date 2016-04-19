//
//  ListItem.h
//  BYDailyNews
//
//  Created by 财通网络 on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InterestListItem : UIButton
{
@public
    NSMutableArray *locateView;
    NSMutableArray *topView;
    NSMutableArray *bottomView;
}

@property (nonatomic,strong) UIView   *hitTextLabel;
@property (nonatomic,strong) UIButton *deleteBtn;//删除
@property (nonatomic,strong) UIButton *hiddenBtn;//遮挡
@property (nonatomic,assign) itemLocation location;//位置
@property (nonatomic,copy) NSString *itemName;

@property (nonatomic,copy) void(^longPressBlock)();
@property (nonatomic,copy) void(^operationBlock)(animateType type, NSString *itemName, int index);

//手势
@property (nonatomic,strong) UIPanGestureRecognizer *gesture;
@property (nonatomic,strong) UILongPressGestureRecognizer *longGesture;
//添加元素
@property (nonatomic, strong) UIButton *rianglebutton;
@property (nonatomic, strong) UILabel *contentLabel;

@end
