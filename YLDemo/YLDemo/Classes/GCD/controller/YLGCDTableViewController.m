//
//  YLGCDTableViewController.m
//  YLDemo
//
//  Created by WYL on 16/1/20.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import "YLGCDTableViewController.h"
#import "YLContentModel.h"

#import "YLSemaphoreViewController.h"

@interface YLGCDTableViewController ()

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation YLGCDTableViewController

- (NSArray *)dataSource
{
    if(_dataSource == nil)
    {
        YLContentModel *semaphore = [YLContentModel contentModelWithTitle:@"信号量 semaphore" viewControllerName:@"YLSemaphoreViewController"];
        _dataSource = @[semaphore];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"GCD";
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *GCDIdentifier = @"GCDTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GCDIdentifier];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:GCDIdentifier];
    }
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
