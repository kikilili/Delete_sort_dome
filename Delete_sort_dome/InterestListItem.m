//
//  ListItem.m
//  BYDailyNews
//
//  Created by 财通网络 on 16/3/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "InterestListItem.h"

#define kDeleteW 6
#define kItemFont 13
#define kItemSizeChangeAdded 2

@implementation InterestListItem
-(void)setItemName:(NSString *)itemName{
    _itemName = itemName;
    
    /**初始化按钮*/
//    [self setTitle:itemName forState:UIControlStateNormal];
        [self setTitleColor:RGBColor(111.0, 111.0, 111.0) forState:0];
    self.titleLabel.font = [UIFont systemFontOfSize:kItemFont];
    self.layer.cornerRadius = 4;
    self.layer.borderColor = [RGBColor(200.0, 200.0, 200.0) CGColor];
    self.layer.borderWidth = 0.5;
    self.backgroundColor = [UIColor whiteColor];
    [self addTarget:self
             action:@selector(operationWithoutHidBtn)
   forControlEvents:UIControlEventTouchUpInside];
    
    // **********************   在按钮上面添加要显示的文字图片等  **********************
    /**显示文字的label*/
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70)];
    contentLabel.backgroundColor = [UIColor yellowColor];
    contentLabel.text = itemName;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    
    if (![itemName isEqualToString:@"社会"] && ![itemName isEqualToString:@"娱乐"]) {
        //三角按钮
        _rianglebutton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _rianglebutton.frame = CGRectMake(0, contentLabel.frame.origin.y + contentLabel.frame.size.height, self.frame.size.width, 30);
        [_rianglebutton addTarget:self action:@selector(rianglebuttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
        _rianglebutton.backgroundColor = [UIColor grayColor];
        [_rianglebutton setTitle:@"san" forState:(UIControlStateNormal)];
        [self addSubview:_rianglebutton];
    }else
    {
        contentLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    
    self.gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pangestureOperation:)];
    self.longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    self.longGesture.minimumPressDuration = 1;  /*允许当前长按最小的时长*/
    self.longGesture.allowableMovement = 20;
    [self addGestureRecognizer:self.longGesture];
    
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 2*kDeleteW, -kDeleteW-4, 4*kDeleteW, 4*kDeleteW)];
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete.png"] forState:0];
    self.deleteBtn.layer.cornerRadius = self.deleteBtn.frame.size.width/2;
    self.deleteBtn.hidden = YES;
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.deleteBtn.backgroundColor = RGBColor(111.0, 111.0, 111.0);
    [self addSubview:self.deleteBtn];
    
    if (!self.hiddenBtn) {
        self.hiddenBtn = [[UIButton alloc] initWithFrame:contentLabel.frame];
        self.hiddenBtn.hidden = NO;
        [self.hiddenBtn addTarget:self
                           action:@selector(operationWithHidBtn)
                 forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.hiddenBtn];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sortButtonClick)
                                                 name:@"sortBtnClick"
                                               object:nil];
}

- (void)rianglebuttonClick:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Foreigncurrency"
                                                        object:sender
                                                      userInfo:nil];
}

//删除
- (void)deleteBtnClick{
    if (self.location == top){
        [self changeFromTopToBottom];
    }
}

-(void)longPress{
    if (self.hiddenBtn.hidden == NO) {
        if (self.longPressBlock) {
            self.longPressBlock();
        }
        if (self.location == top) {
            
            [self addGestureRecognizer:self.gesture];
        }
    }
}

-(void)sortButtonClick{
    if (self.location == top){
        self.deleteBtn.hidden = !self.deleteBtn.hidden;
    }
    self.hiddenBtn.hidden = !self.hiddenBtn.hidden;
    if (self.gestureRecognizers) {
        [self removeGestureRecognizer:self.gesture];
    }
    if (self.hiddenBtn.hidden && self.location == top) {
        [self addGestureRecognizer:self.gesture];
    }
}

-(void)operationWithHidBtn{
    if (!self.hiddenBtn.hidden) {
        if (self.location == top) {
            [self setTitleColor:[UIColor redColor] forState:0];
            if (self.operationBlock) {
                self.operationBlock(topViewClick,self.titleLabel.text,0);
            }
            [self animationForWholeView];
        }
        else if (self.location == bottom){
            [self changeFromBottomToTop];
        }
    }
}

-(void)operationWithoutHidBtn{
    if (self.location == bottom) {
        self.deleteBtn.hidden = NO;
        [self addGestureRecognizer:self.gesture];
        [self addGestureRecognizer:_longGesture];
        [self changeFromBottomToTop];
    }
}

- (void)pangestureOperation:(UIPanGestureRecognizer *)pan{
    [self.superview exchangeSubviewAtIndex:[self.superview.subviews indexOfObject:self] withSubviewAtIndex:[[self.superview subviews] count] - 1];
    CGPoint translation = [pan translationInView:pan.view];
    CGPoint center = pan.view.center;
    center.x += translation.x;
    center.y += translation.y;
    pan.view.center = center;
    [pan setTranslation:CGPointZero inView:pan.view];
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:{
            CGRect itemFrame = self.frame;
            [self setFrame:CGRectMake(itemFrame.origin.x-kItemSizeChangeAdded, itemFrame.origin.y-kItemSizeChangeAdded, itemFrame.size.width+kItemSizeChangeAdded*2, itemFrame.size.height+kItemSizeChangeAdded*2)];
        }
            break;
        case UIGestureRecognizerStateChanged:{
            BOOL InTopView = [self whetherInAreaWithArray:topView Point:center];
            if (InTopView) {
                NSLog(@"++++");
                NSInteger indexX = (center.x <= kItemW+2*padding)? 0 : (center.x - kItemW-2*padding)/(padding+kItemW) + 1;
                NSInteger indexY = (center.y <= kItemH+2*padding)? 0 : (center.y - kItemH-2*padding)/(padding+kItemH) + 1;
                
                NSInteger index = indexX + indexY*itemPerLine;
                index = (index == 0)? 1:index;
                [locateView removeObject:self];
                [topView insertObject:self atIndex:index];
                locateView = topView;
                [self animationForTopView];
                if (self.operationBlock) {
                    self.operationBlock(FromTopToTop,self.titleLabel.text,(int)index);
                }
            }
            else if (!InTopView && center.y < [self TopViewMaxY]+50) {
                
                NSLog(@"_____");
                [locateView removeObject:self];
                [topView insertObject:self atIndex:topView.count];
                locateView = topView;
                [self animationForTopView];
                if (self.operationBlock) {
                    self.operationBlock(FromTopToTopLast,self.titleLabel.text,0);
                }
            }
            else if (center.y > [self TopViewMaxY]+50){
                
                NSLog(@" /// ");
                [self changeFromTopToBottom];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            
            NSLog(@" ------ ");
            [self animationForWholeView];
            break;
    }
}

-(void)changeFromTopToBottom{
    [locateView removeObject:self];
    [bottomView insertObject:self atIndex:0];
    locateView = bottomView;
    self.location = bottom;
    self.deleteBtn.hidden = YES;
    [self removeGestureRecognizer:self.gesture];
    if (self.operationBlock) {
        self.operationBlock(FromTopToBottomHead,self.titleLabel.text,0);
    }
    [self animationForWholeView];
}

//=========================
-(void)changeFromBottomToTop{
    
    [locateView removeObject:self];
    [topView insertObject:self atIndex:topView.count];
    locateView = topView;
    self.location = top;
    if (self.operationBlock) {
        self.operationBlock(FromBottomToTopLast,self.titleLabel.text,0);
    }
    
    
    [self animationForWholeView];
    
}

- (BOOL)whetherInAreaWithArray:(NSMutableArray *)array Point:(CGPoint)point{
    int row = (array.count%itemPerLine == 0)? itemPerLine : array.count%itemPerLine;
    int column =  (int)(array.count-1)/itemPerLine+1;
    if ((point.x > 0 && point.x <=kScreenW &&point.y > 0 && point.y <= (kItemH + padding)*(column-1)+padding)||
        (point.x > 0 && point.x <= (row*(padding+kItemW)+padding)&& point.y > (kItemH + padding)*(column -1)+padding && point.y <= (kItemH+padding) * column+padding)){
        return YES;
    }
    return NO;
}

- (unsigned long)TopViewMaxY{
    unsigned long y = 0;
    y = ((topView.count-1)/itemPerLine+1)*(kItemH + padding) + padding + 40;//点击添加不会被遮盖
    return y;
}


- (void)animationForTopView{
    for (int i = 0; i < topView.count; i++){
        if ([topView objectAtIndex:i] != self){
            [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), padding+(kItemH + padding)*(i/itemPerLine) + 40/*加上高度*/, kItemW, kItemH)];
        }
    }
}
-(void)animationForBottomView{
    for (int i = 0; i < bottomView.count; i++) {
        if ([bottomView objectAtIndex:i] != self) {
            [self animationWithView:[bottomView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), [self TopViewMaxY]+50+(kItemH+padding)*(i/itemPerLine), kItemW, kItemH)];
        }
    }
    [self animationWithView:self.hitTextLabel frame:CGRectMake(0,[self TopViewMaxY],kScreenW,30)];
}

- (void)animationForWholeView{
    for (int i = 0; i <topView.count; i++) {
        [self animationWithView:[topView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), padding+(padding+kItemH)*(i/itemPerLine) + 40/*加上高度*/, kItemW, kItemH)];
    }
    for (int i = 0; i < bottomView.count; i++) {
        [self animationWithView:[bottomView objectAtIndex:i] frame:CGRectMake(padding+(padding+kItemW)*(i%itemPerLine), [self TopViewMaxY]+50+(kItemH+padding)*(i/itemPerLine), kItemW, kItemH)];
    }
    [self animationWithView:self.hitTextLabel frame:CGRectMake(0,[self TopViewMaxY],kScreenW,30)];
}

-(void)animationWithView:(UIView *)view frame:(CGRect)frame{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        [view setFrame:frame];
    } completion:^(BOOL finished){
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
