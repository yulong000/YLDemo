//
//  YLContentModel.m
//  YLDemo
//
//  Created by WYL on 16/1/13.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import "YLContentModel.h"

@implementation YLContentModel

- (instancetype)initWithTitle:(NSString *)title viewControllerName:(NSString *)viewController
{
    if(self = [super init])
    {
        _title = title;
        _viewController = viewController;
    }
    return self;
}

+ (instancetype)contentModelWithTitle:(NSString *)title viewControllerName:(NSString *)viewController
{
    return [[super alloc] initWithTitle:title viewControllerName:viewController];
}

@end
