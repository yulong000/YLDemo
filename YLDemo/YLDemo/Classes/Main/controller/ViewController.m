//
//  ViewController.m
//  YLDemo
//
//  Created by WYL on 16/1/13.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import "ViewController.h"
#import "YLContentModel.h"

#import "YLAnimationViewController.h"
#import "YLMultiThreadViewController.h"

@interface ViewController () < UITableViewDataSource, UITableViewDelegate, UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (NSArray *)dataSource
{
    if(_dataSource == nil)
    {
        YLContentModel *animation = [YLContentModel contentModelWithTitle:@"Animation" viewControllerName:@"YLAnimationViewController"];
        YLContentModel *GCD = [YLContentModel contentModelWithTitle:@"多线程" viewControllerName:@"YLMultiThreadViewController"];
        _dataSource = @[animation, GCD];
    }
    return _dataSource;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Demo";
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.frame = self.view.bounds;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 70;
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MainTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [self addPeekAndPopWithCell:cell];
    YLContentModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.viewController;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YLContentModel *model = self.dataSource[indexPath.row];
    Class distanceVc = NSClassFromString(model.viewController);
    UIViewController *vc = [[[distanceVc class] alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark 给 cell 添加3D touch
- (void)addPeekAndPopWithCell:(UITableViewCell *)cell {
    // 3d touch 需要在真机下才能测试 iOS 9.0以后才可以使用
    if([UIDevice currentDevice].systemVersion.floatValue < 9.0)    return;
    if(self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        [self registerForPreviewingWithDelegate:self sourceView:cell];
    }
}

#pragma mark - UIViewControllerPreviewingDelegate
#pragma mark peek
- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    // location : 按压点在sourceView中的相对位置, 可根据 location 的不同,展示不同的页面
    // previewingContext : 可以获取到呼出的 view, 设置动画出现的 rect
    // 预览页上滑出现的菜单, 在预览的控制器内设置, 重写 - (NSArray<id<UIPreviewActionItem>> *)previewActionItems; 方法, 返回对应的菜单及对应的操作
    // 从 cell 的左半部分呼出动画
    // previewingContext.sourceRect = CGRectMake(0, 0, previewingContext.sourceView.frame.size.width * 0.5, previewingContext.sourceView.frame.size.height);
    UITableViewCell *cell = (UITableViewCell *)previewingContext.sourceView;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YLContentModel *model = self.dataSource[indexPath.row];
    // 预览的 controller
    Class distanceVc = NSClassFromString(model.viewController);
    UIViewController *vc = [[[distanceVc class] alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    // 设置预览页的高度
    vc.preferredContentSize = CGSizeMake(0, arc4random() % 200 + 100);
    return vc;
}
#pragma mark pop
- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    UITableViewCell *cell = (UITableViewCell *)previewingContext.sourceView;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YLContentModel *model = self.dataSource[indexPath.row];
    // 预览的 controller
    Class distanceVc = NSClassFromString(model.viewController);
    UIViewController *vc = [[[distanceVc class] alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
