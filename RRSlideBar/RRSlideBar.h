//
//  RRSlideBar.h
//  RRSlideBar
//
//  Created by 游侠 on 2017/11/15.
//  Copyright © 2017年 ranger. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^selectedTagBlock)(NSInteger tag);

@interface RRSlideBar : UIView

@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,copy) selectedTagBlock block;
@property (nonatomic,strong) UIView *lineView;//
@property (nonatomic,strong) UIButton *selectedBtn;//当前被选中的按键
@property (nonatomic,strong) UIColor *norColor;//未选中状态颜色
@property (nonatomic,strong) UIColor *selColor;//选中状态颜色
@property (nonatomic,assign) CGFloat gap;//分栏之间的间隔

-(void)selectedBtnCallback:(selectedTagBlock)block;
-(void)tapScrollTo:(NSInteger)index;

@end
