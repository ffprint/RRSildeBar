//
//  ViewController.m
//  RRSlideBar
//
//  Created by 游侠 on 2017/11/15.
//  Copyright © 2017年 ranger. All rights reserved.
//

#import "ViewController.h"
#import "RRSlideBar.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) RRSlideBar *bar;
@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self initTableView];
    self.bar = [[RRSlideBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 43)];
    [self.bar selectedBtnCallback:^(NSInteger tag) {
        [self.tableView setContentOffset:CGPointMake(0, self.view.frame.size.width * tag) animated:false];
    }];
    self.titleArray = @[@"首页",@"每日资讯",@"游戏",@"影音娱乐",@"天下新闻",@"音乐",@"二次元",@"政治",@"商业",@"生活",@"美食",@"创意",@"天气"];
    self.bar.titleArray = self.titleArray;
    [self.view addSubview:self.bar];
    [self.view bringSubviewToFront:self.bar];
}

-(void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxY(self.view.frame), CGRectGetWidth(self.view.frame))];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    self.tableView.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
    self.tableView.showsVerticalScrollIndicator = false;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.pagingEnabled = true;
    if (@available(iOS 11.0,*)) {
        //去掉顶端20空白,UIScrollView同样适用
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {}
    [self.view addSubview:self.tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    int r = arc4random() % 255;
    int g = arc4random() % 255;
    int b = arc4random() % 255;
    cell.contentView.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetWidth(self.view.frame);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
    [self.bar tapScrollTo:indexPath.row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
