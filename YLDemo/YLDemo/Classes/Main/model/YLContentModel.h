//
//  YLContentModel.h
//  YLDemo
//
//  Created by WYL on 16/1/13.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLContentModel : NSObject

/**
 *  内容标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  跳转的控制器
 */
@property (nonatomic, copy) NSString *viewController;


- (instancetype)initWithTitle:(NSString *)title viewControllerName:(NSString *)viewController;
+ (instancetype)contentModelWithTitle:(NSString *)title viewControllerName:(NSString *)viewController;

@end
