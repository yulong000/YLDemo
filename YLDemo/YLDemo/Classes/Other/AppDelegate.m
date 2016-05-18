//
//  AppDelegate.m
//  YLDemo
//
//  Created by WYL on 16/1/13.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

NSString *kShortcutItemTypeHome = @"kShortcutItemTypeHome";
NSString *kShortcutItemTypeAdd  = @"kShortcutItemTypeAdd";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // app icon 的3d touch 菜单
    // method 1 动态标签
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeHome];
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc] initWithType:kShortcutItemTypeHome localizedTitle:@"home" localizedSubtitle:@"首页" icon:icon1 userInfo:nil];
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc] initWithType:kShortcutItemTypeAdd localizedTitle:@"add" localizedSubtitle:@"添加" icon:icon2 userInfo:nil];
    application.shortcutItems = @[item1, item2];
    
    // method 2
    /*
     在 plist 文件中配置静态标签 , 无提示, 需手动输入
     UIApplicationShortcutItems：数组中的元素就是我们的那些快捷选项标签。
     每个 item 以字典形式存在, key 值如下:
     UIApplicationShortcutItemTitle：标签标题（必填）
     UIApplicationShortcutItemType：标签的唯一标识 （必填）
     UIApplicationShortcutItemIconType：使用系统图标的类型，如搜索、定位、home等（可选）
     UIApplicationShortcutItemIcon File：使用项目中的图片作为标签图标 （可选）
     UIApplicationShortcutItemSubtitle：标签副标题 （可选）
     UIApplicationShortcutItemUserInfo：字典信息，如传值使用 （可选）
     */
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    if(shortcutItem) {
        // 判断是不是由快捷标签进入的,如果是, 返回 NO, 防止调用
        // - (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler 方法, 重复操作
        [self handlerShortcutItem:shortcutItem];
        return NO;
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 执行 3D 菜单
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [self handlerShortcutItem:shortcutItem];
}

- (void)handlerShortcutItem:(UIApplicationShortcutItem *)shortcutItem {
    if([shortcutItem.type isEqualToString:kShortcutItemTypeHome]) {
        NSLog(@"operation home");
    } else if ([shortcutItem.type isEqualToString:kShortcutItemTypeAdd]) {
        NSLog(@"operation add");
    }
}

@end
