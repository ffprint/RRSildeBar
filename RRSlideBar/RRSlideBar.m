//
//  RRSlideBar.m
//  RRSlideBar
//
//  Created by 游侠 on 2017/11/15.
//  Copyright © 2017年 ranger. All rights reserved.
//

#import "RRSlideBar.h"

@interface RRSlideBar()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;


@end

@implementation RRSlideBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.norColor = [UIColor blackColor];
        self.selColor = [UIColor redColor];
        self.gap = 10;
        [self addShadowOffset:CGSizeMake(0, 3) radius:2 color:[UIColor grayColor] opacity:0.5];
        [self initSubViews];
    }
    return self;
}

-(void)initSubViews {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.showsVerticalScrollIndicator = false;
    _scrollView.showsHorizontalScrollIndicator = false;
    _scrollView.bounces = true;
    _scrollView.delegate = self;
    _scrollView.alwaysBounceHorizontal = true;
    [self addSubview:_scrollView];
}

-(void)setTitleArray:(NSArray *)titleArray {
    _titleArray = titleArray;
    CGFloat btn_X = 0;
    CGFloat wid = self.gap * (titleArray.count + 1);
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i + 10;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGSize size = [titleArray[i] sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil]];
        btn.frame = CGRectMake(btn_X + self.gap, 5, size.width, 30);
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.norColor forState:(UIControlStateNormal)];
        btn.titleLabel.font = font;
        wid += size.width;
        [btn setTitleColor:self.selColor forState:(UIControlStateSelected)];
        btn_X += size.width + self.gap;
        if (i == 0) {
            [btn setSelected:true];
            _selectedBtn = btn;
            _lineView = [[UIView alloc] initWithFrame:CGRectMake(btn.frame.origin.x + 5, btn.frame.origin.y + btn.frame.size.height, btn.frame.size.width-10, 2)];
            _lineView.backgroundColor = self.selColor;
            _lineView.layer.cornerRadius = 1;
            [_scrollView addSubview:_lineView];
        }
        [_scrollView addSubview:btn];
    }
    _scrollView.contentSize = CGSizeMake(wid, self.frame.size.height);
}

-(void)btnClick:(UIButton *)sender {
    [_selectedBtn setSelected:false];
    _selectedBtn = sender;
    [_selectedBtn setSelected:true];
    [self moveLineTo:sender.tag];
    _block(sender.tag - 10);
}

-(void)moveLineTo:(NSInteger)tag {
    CGPoint offset = _scrollView.contentOffset;
    CGFloat sizeWidth = _scrollView.contentSize.width;
    UIButton *btn = [self viewWithTag:tag];
    CGRect frame = _lineView.frame;
    frame.origin.x = btn.frame.origin.x+5;
    frame.size.width = btn.frame.size.width-10;
    [UIView animateWithDuration:0.2 animations:^{
        _lineView.frame = frame;//线移动
            //从右滑到最左端
        if (btn.frame.origin.x + btn.frame.size.width/2 < self.frame.size.width/2) {
            [_scrollView setContentOffset:CGPointMake(0, offset.y) animated:true];
        }else if (btn.frame.origin.x + btn.frame.size.width/2 > self.frame.size.width/2 && sizeWidth - btn.frame.origin.x - btn.frame.size.width/2 > self.frame.size.width/2) {
            //使中间部分居中
            [_scrollView setContentOffset:CGPointMake(btn.frame.origin.x + btn.frame.size.width/2 - self.frame.size.width/2, offset.y) animated:true];
        }else if (sizeWidth - btn.frame.origin.x - btn.frame.size.width/2 < self.frame.size.width/2) {
            //从左端滑到最右端
            [_scrollView setContentOffset:CGPointMake(sizeWidth - self.frame.size.width, offset.y) animated:true];
        }
    }];
}

-(void)selectedBtnCallback:(selectedTagBlock)block {
    _block = block;
}

//控制器拖拽视图，RRSlideBar改变状态
-(void)tapScrollTo:(NSInteger)index {
    [self tapBtnClick:index];
}

-(void)tapBtnClick:(NSInteger)index {
    [_selectedBtn setSelected:false];
    UIButton *btn = [self viewWithTag:index + 10];
    _selectedBtn = btn;
    [_selectedBtn setSelected:true];
    [self moveLineTo:index + 10];
}

//阴影效果
-(void)addShadowOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, &CGAffineTransformIdentity, self.bounds);
    self.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowRadius = radius;
    self.layer.shadowOpacity = opacity;
    self.clipsToBounds = false;
}


@end















