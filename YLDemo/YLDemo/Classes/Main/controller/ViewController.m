//
//  ViewController.m
//  YLDemo
//
//  Created by WYL on 16/1/13.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import "ViewController.h"
#import "YLContentModel.h"

@interface ViewController () < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (NSArray *)dataSource
{
    if(_dataSource == nil)
    {
        _dataSource = @[];
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
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    YLContentModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.viewController;
    return cell;
}

@end
