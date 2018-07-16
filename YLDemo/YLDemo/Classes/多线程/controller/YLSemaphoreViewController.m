//
//  YLSemaphoreViewController.m
//  YLDemo
//
//  Created by WYL on 16/1/20.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import "YLSemaphoreViewController.h"

@interface YLSemaphoreViewController ()

@end

@implementation YLSemaphoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"semaphore";
    
    [self performSelectorInBackground:@selector(test) withObject:nil];
}

- (void)info
{
    /*
        信号量是一个整形值并且具有一个初始计数值，并且支持两个操作：信号通知和等待。
        当一个信号量被信号通知，其计数会被增加。当一个线程在一个信号量上等待时，线程会被阻塞（如果有必要的话），直至计数器大于零，然后线程会减少这个计数。
     
     　　在GCD中有三个函数是semaphore的操作，分别是：
     　　dispatch_semaphore_create　　　创建一个semaphore, 有一个整形的参数，我们可以理解为信号的总量
     　　dispatch_semaphore_signal　　　发送一个信号, 会让信号总量加1
     　　dispatch_semaphore_wait　　　　等待信号, 当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1
     
     　　根据这样的原理，我们便可以快速的创建一个并发控制来同步任务和有限资源访问控制。
     */
}

- (void)test
{
    /*
     简单的介绍一下这一段代码:
     创建了一个初使值为10的semaphore，每一次for循环都会创建一个新的线程，线程结束的时候会发送一个信号，线程创建之前会信号等待
     所以当同时创建了10个线程之后，for循环就会阻塞，等待有线程结束之后会增加一个信号才继续执行，如此就形成了对并发的控制，就是一个并发数为10的一个线程队列。
     */
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
           
            NSLog(@"%i", i);
            sleep(5);
            dispatch_semaphore_signal(semaphore);
        });
    }
    NSLog(@"wait");
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    NSLog(@"end");
}

- (void)test2
{
    NSString *imageUrl = @"http://img2.imgtn.bdimg.com/it/u=2749032785,4112802673&fm=21&gp=0.jpg";
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error == nil && data.length)
        {
            // 获取到数据
            NSLog(@"success");
        }
        else
        {
            NSLog(@"failure");
        }
        dispatch_semaphore_signal(semaphore);
        
    }];
    
    [task resume];
    dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, 1 * 1000 * 1000 * 1000));
    
    NSLog(@"end");
}

- (void)test3   // ok
{
    int data = 3;
    __block int mainData = 0;
    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    
    dispatch_queue_t queue = dispatch_queue_create("StudyBlocks", NULL);
    
    dispatch_async(queue, ^(void) {
        int sum = 0;
        for(int i = 0; i < 5; i++)
        {
            sum += data;
            
            NSLog(@" >> Sum: %d", sum);
        }
        
        dispatch_semaphore_signal(sem);
    });
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    for(int j=0;j<5;j++)
    {
        mainData++;
        NSLog(@">> Main Data: %d",mainData);
    }
}

@end
