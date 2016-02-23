//
//  YLThreadCreateViewController.m
//  YLDemo
//
//  Created by WYL on 16/2/19.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import "YLThreadCreateViewController.h"

@interface YLThreadCreateViewController ()

@end

@implementation YLThreadCreateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"多线程创建的方法";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self NSOperation];
}

#pragma mark - 多线程的四种创建方式

#pragma mark - pthread
- (void)pthread
{
    // 几乎很少用, 暂不做介绍
}

#pragma mark - NSThread

- (void)NSThread
{
    // 线程的三种创建方式
    // 1.可以设置线程的名字, 方便查找, 需要手动开始
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:@"thread-A"];
    thread.name = @"my-thread";
//    thread.threadPriority = 0.5;    // 线程的调度优先级, 0.1~1.0, default = 0.5, 值越大, 优先级越高 一般不做设置, 只在大批量数据时能体现出差异
    [thread start];
    
    // 2.创建简单, 创建完成后自动开始, 不可设置其他信息
//    [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@"thread-B"];
    
    // 3.同创建方法2
//    [self performSelectorInBackground:@selector(run:) withObject:@"thread-C"];
}

- (void)run:(NSString *)str
{
    for (int i = 0; i < 20; i++)
    {
        if(i == 10)
        {
            // 当 i == 10 时, 线程阻塞3.0后继续执行
            //            [NSThread sleepForTimeInterval:3.];
            [NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:3.]];
        }
        
        if(i == 17)
        {
            // 当 i == 17 时, 强制退出线程, 一旦退出, 则不能恢复
            [NSThread exit];
        }
        NSLog(@"- %d -- %@ -- %@", i, [NSThread currentThread], str);
    }
}

#pragma mark  线程间的资源共享
// 火车站卖票
static unsigned int tickets = 20;
- (void)createThreads
{
    tickets = 20;
    NSThread *threadA = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    threadA.name = @"售票员 - A";
    [threadA start];
    
    NSThread *threadB = [[NSThread alloc] initWithTarget:self selector:@selector(saleTickets) object:nil];
    threadB.name = @"售票员 - B";
    [threadB start];
}
- (void)saleTickets
{
    while (YES)
    {
        [NSThread sleepForTimeInterval:1.0];    // 模拟延时1s
        
        // 多个线程访问同一个资源的时候, 可以加 互斥锁, 加过互斥锁的代码, 同一时间只会允许一个线程访问.
        // 互斥锁的参数, 可以为任意 oc 对象(且只能是同一个对象), 但必须让所有参与的线程都能访问到, 所以一般用 self
        @synchronized(self) {
            
            if(tickets > 0)
            {
                tickets--;
                NSLog(@"还剩 %d 张票 -- %@", tickets, [NSThread currentThread]);
            }
            else
            {
                NSLog(@"票卖完了");
                break;
            }
        }
        
    }
}



#pragma mark - GCD

- (void)GCD
{
    /*
     
     任务: block
     队列: 把任务放到队列里面, 队列执行先进先出的原则
     
     串行队列: 顺序执行, 一个一个执行, 必须一个任务执行完毕了, 才能从队列里取出下一个任务执行
     并发队列: 同时执行, 同时执行多个任务
     
     同步: sync 不会开辟新的线程, 在当前线程内执行
     异步: async 会开辟新的线程, 在新线程内执行
     
     串行队列同步执行: 不开新的线程, 在当前线程内一个一个顺序执行
     串行队列异步执行: 开一条新的线程, 在这个新的线程内一个一个顺序执行
     并发队列同步执行: 不开新的线程, 在当前线程内一个一个顺序执行
     并发队列异步执行: 开多条新的线程, 并发执行, 同时执行多个任务
     
     总结:
     1. 同步任务不开辟新的线程, 异步肯定开辟新的线程
     2. 开多少线程, 由队列决定, 串行队列最多开一条线程, 并发可以开辟多条线程, 具体开多少条, 由 GCD 内部控制
     
     */
}

#pragma mark 串行队列同步执行
/**
 *  在当前线程(示例中为主线程)中一个一个任务执行,
 */
- (void)GCD_test1
{
    // 创建一条串行队列, 2种方式都可以, DISPATCH_QUEUE_SERIAL == NULL
//    dispatch_queue_t queue = dispatch_queue_create("test1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue = dispatch_queue_create("test1", NULL);
    
    NSLog(@"开始");
    
    // 同步执行, 串行队列对添加的同步任务, 会立刻执行
    for(int i = 0; i < 10; i++)
    {
        dispatch_sync(queue, ^{
            
            NSLog(@"%@  -- %d", [NSThread currentThread], i);
        });
    }
    
    NSLog(@"完成");
    
    /*
     
     2016-02-23 14:50:35.514 YLDemo[29130:12534553] 开始
     2016-02-23 14:50:35.515 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 0
     2016-02-23 14:50:35.515 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 1
     2016-02-23 14:50:35.515 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 2
     2016-02-23 14:50:35.515 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 3
     2016-02-23 14:50:35.515 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 4
     2016-02-23 14:50:35.515 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 5
     2016-02-23 14:50:35.515 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 6
     2016-02-23 14:50:35.516 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 7
     2016-02-23 14:50:35.516 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 8
     2016-02-23 14:50:35.516 YLDemo[29130:12534553] <NSThread: 0x7ffd9ac089d0>{number = 1, name = main}  -- 9
     2016-02-23 14:50:35.516 YLDemo[29130:12534553] 完成
     
     */
}

#pragma mark 串行队列异步执行
/**
 *  会开辟一条新的线程, 所有任务在新线程中一个一个顺序执行, 当前任务(GCD_test2)执行完毕后开始执行
 */
- (void)GCD_test2
{
    // 创建一条串行队列
    dispatch_queue_t queue = dispatch_queue_create("test2", DISPATCH_QUEUE_SERIAL);
    
    NSLog(@"开始");
    
    // 异步执行
    for(int i = 0; i < 10; i++)
    {
        dispatch_async(queue, ^{
            
            NSLog(@"%@  -- %d", [NSThread currentThread], i);
        });
    }
    
    NSLog(@"完成");
    
    /*
     
     2016-02-23 14:51:09.434 YLDemo[29148:12539682] 开始
     2016-02-23 14:51:09.434 YLDemo[29148:12539682] 完成
     2016-02-23 14:51:09.434 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 0
     2016-02-23 14:51:09.435 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 1
     2016-02-23 14:51:09.435 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 2
     2016-02-23 14:51:09.435 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 3
     2016-02-23 14:51:09.435 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 4
     2016-02-23 14:51:09.435 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 5
     2016-02-23 14:51:09.436 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 6
     2016-02-23 14:51:09.436 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 7
     2016-02-23 14:51:09.436 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 8
     2016-02-23 14:51:09.436 YLDemo[29148:12539986] <NSThread: 0x7fcab0459260>{number = 3, name = (null)}  -- 9
     
     */
}

#pragma mark 并发队列同步执行
/**
 *  不会开辟新的线程, 在当前线程中(示例中为主线程), 所有任务一个一个顺序执行
 */
- (void)GCD_test3
{
    // 创建一条并发队列
    dispatch_queue_t queue = dispatch_queue_create("test3", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"开始");
    
    // 同步执行任务
    for(int i = 0; i < 10; i++)
    {
        dispatch_sync(queue, ^{
           
            NSLog(@"%@  -- %d", [NSThread currentThread], i);
        });
    }
    
    NSLog(@"完成");
    
    /*
     
     2016-02-23 15:03:19.798 YLDemo[29282:12572099] 开始
     2016-02-23 15:03:19.798 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 0
     2016-02-23 15:03:19.798 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 1
     2016-02-23 15:03:19.798 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 2
     2016-02-23 15:03:19.799 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 3
     2016-02-23 15:03:19.799 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 4
     2016-02-23 15:03:19.799 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 5
     2016-02-23 15:03:19.799 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 6
     2016-02-23 15:03:19.799 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 7
     2016-02-23 15:03:19.799 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 8
     2016-02-23 15:03:19.799 YLDemo[29282:12572099] <NSThread: 0x7f9ceb506be0>{number = 1, name = main}  -- 9
     2016-02-23 15:03:19.799 YLDemo[29282:12572099] 结束
     
     */
}

#pragma mark 并发队列异步执行
/**
 *  会开辟多条新的线程, 可以同时执行多个任务, 任务完成的先后顺序不定
 */
- (void)GCD_test4
{
    // 创建一条并发队列
    dispatch_queue_t queue = dispatch_queue_create("test4", DISPATCH_QUEUE_CONCURRENT);
    
    NSLog(@"开始");
    
    // 同步执行任务
    for(int i = 0; i < 10; i++)
    {
        dispatch_async(queue, ^{
            
            NSLog(@"%@  -- %d", [NSThread currentThread], i);
        });
    }
    
    NSLog(@"完成");
    
    /*
     
     2016-02-23 15:07:25.584 YLDemo[29333:12590667] 开始
     2016-02-23 15:07:25.585 YLDemo[29333:12590667] 结束
     2016-02-23 15:07:25.585 YLDemo[29333:12591476] <NSThread: 0x7ff3bbea05f0>{number = 8, name = (null)}  -- 4
     2016-02-23 15:07:25.585 YLDemo[29333:12590991] <NSThread: 0x7ff3bda00b60>{number = 5, name = (null)}  -- 3
     2016-02-23 15:07:25.585 YLDemo[29333:12590992] <NSThread: 0x7ff3bd907bf0>{number = 3, name = (null)}  -- 1
     2016-02-23 15:07:25.585 YLDemo[29333:12591479] <NSThread: 0x7ff3bbcbfcb0>{number = 6, name = (null)}  -- 7
     2016-02-23 15:07:25.585 YLDemo[29333:12590967] <NSThread: 0x7ff3bdb00bf0>{number = 4, name = (null)}  -- 2
     2016-02-23 15:07:25.585 YLDemo[29333:12591477] <NSThread: 0x7ff3bbd2d250>{number = 9, name = (null)}  -- 5
     2016-02-23 15:07:25.585 YLDemo[29333:12591478] <NSThread: 0x7ff3bbd4b5e0>{number = 7, name = (null)}  -- 6
     2016-02-23 15:07:25.585 YLDemo[29333:12590966] <NSThread: 0x7ff3bbe07360>{number = 2, name = (null)}  -- 0
     2016-02-23 15:07:25.585 YLDemo[29333:12591476] <NSThread: 0x7ff3bbea05f0>{number = 8, name = (null)}  -- 8
     2016-02-23 15:07:25.585 YLDemo[29333:12590991] <NSThread: 0x7ff3bda00b60>{number = 5, name = (null)}  -- 9
     
     */
}

#pragma mark 主队列异步执行
/**
 *  专门负责主线程上的调度任务, 不会在子线程上调度任务, 在主队列不允许开新线程
 *  异步: 会开辟新的线程, 在新的线程上执行,
 *  结果: 不开新的线程, 只能在主线程上 顺序执行
 */
- (void)GCD_test5
{
    // 获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"开始");
    
    // 异步执行
    for(int i = 0; i < 10; i++)
    {
        NSLog(@"----");
        dispatch_async(queue, ^{
           
            NSLog(@"%@ -- %d", [NSThread currentThread], i);
        });
        NSLog(@"休眠1s");
        [NSThread sleepForTimeInterval:1.];
    }
    NSLog(@"完成");
    
    /*
     
     2016-02-23 15:14:06.148 YLDemo[29403:12611605] 开始
     2016-02-23 15:14:06.148 YLDemo[29403:12611605] ----
     2016-02-23 15:14:06.148 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:07.149 YLDemo[29403:12611605] ----
     2016-02-23 15:14:07.149 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:08.151 YLDemo[29403:12611605] ----
     2016-02-23 15:14:08.151 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:09.152 YLDemo[29403:12611605] ----
     2016-02-23 15:14:09.152 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:10.154 YLDemo[29403:12611605] ----
     2016-02-23 15:14:10.154 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:11.155 YLDemo[29403:12611605] ----
     2016-02-23 15:14:11.156 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:12.157 YLDemo[29403:12611605] ----
     2016-02-23 15:14:12.158 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:13.159 YLDemo[29403:12611605] ----
     2016-02-23 15:14:13.159 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:14.160 YLDemo[29403:12611605] ----
     2016-02-23 15:14:14.161 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:15.162 YLDemo[29403:12611605] ----
     2016-02-23 15:14:15.162 YLDemo[29403:12611605] 休眠1s
     2016-02-23 15:14:16.164 YLDemo[29403:12611605] 完成
     2016-02-23 15:14:16.164 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 0
     2016-02-23 15:14:16.164 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 1
     2016-02-23 15:14:16.165 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 2
     2016-02-23 15:14:16.165 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 3
     2016-02-23 15:14:16.165 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 4
     2016-02-23 15:14:16.165 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 5
     2016-02-23 15:14:16.166 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 6
     2016-02-23 15:14:16.166 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 7
     2016-02-23 15:14:16.166 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 8
     2016-02-23 15:14:16.166 YLDemo[29403:12611605] <NSThread: 0x7fbf5bc04e20>{number = 1, name = main} -- 9
     
     */
}

#pragma mark 主队列同步执行
/**
 *  同步: 不会开辟新的线程, 在当前线程(即主线程)立刻执行, 而主线程此时有尚未完成的任务(GCD_test6), 造成无法继续执行
 *  结果: 死锁
 */
- (void)GCD_test6
{
    // 获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    NSLog(@"开始");
    
    // 同步执行
    for(int i = 0; i < 10; i++)
    {
        NSLog(@"----");
        dispatch_sync(queue, ^{
            
            NSLog(@"%@ -- %d", [NSThread currentThread], i);
        });
        NSLog(@"休眠1s");
        [NSThread sleepForTimeInterval:1.];
    }
    NSLog(@"完成");
    
    /*
     
     2016-02-23 15:26:20.472 YLDemo[29494:12633594] 开始
     2016-02-23 15:26:20.472 YLDemo[29494:12633594] ----
     
     */
}

#pragma mark 同步任务的作用
/**
 *  登录为同步任务, 2个下载为异步任务, 保证了 只有在用户登录后, 再开始下载任务, 2个下载任务同步执行, 开启多条线程
 */
- (void)GCD_test7
{
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("test7", DISPATCH_QUEUE_CONCURRENT);
    
    // 用户登录成功后, 再开始2个下载任务
    
    // 同步任务, 不会开辟新的线程, 在当前线程(主线程)中立马执行
    dispatch_sync(queue, ^{
       
        NSLog(@"用户登录 %@", [NSThread currentThread]);
    });
    
    // 异步任务, 会开辟新的线程, 在新的线程中执行
    dispatch_async(queue, ^{
       
        NSLog(@"下载 --- 1 %@", [NSThread currentThread]);
    });
    
    // 异步任务, 会开辟新的线程, 在新的线程中执行
    dispatch_async(queue, ^{
       
        NSLog(@"下载 --- 2 %@", [NSThread currentThread]);
    });
    
    /*
     
     2016-02-23 15:34:45.186 YLDemo[29597:12657831] 用户登录 <NSThread: 0x7f8de2d07fb0>{number = 1, name = main}
     2016-02-23 15:34:45.186 YLDemo[29597:12657920] 下载 --- 2 <NSThread: 0x7f8de2f9a700>{number = 4, name = (null)}
     2016-02-23 15:34:45.186 YLDemo[29597:12657925] 下载 --- 1 <NSThread: 0x7f8de4300d20>{number = 3, name = (null)}
     
     */
}

#pragma mark 全局队列
/**
 *  全局队列 是 apple 提供的并发队列, 只是没有名称, 使用方便, 效果等同于并发队列
 */
- (void)GCD_test8
{
    // 获取全局队列
    /**
     第一个参数一般写0, 可以适配 iOS 7 & 8
     
     iOS 7
     DISPATCH_QUEUE_PRIORITY_HIGH 2  高优先级
     DISPATCH_QUEUE_PRIORITY_DEFAULT 0  默认优先级
     DISPATCH_QUEUE_PRIORITY_LOW (-2) 低优先级
     DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN 后台优先级
     
     iOS 8
     QOS_CLASS_DEFAULT  0
     
     
     第二个参数 : 保留参数 0
     
     */
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    NSLog(@"开始");
    
    for(int i = 0; i < 10; i++)
    {
        dispatch_async(queue, ^{
           
            NSLog(@"%@ -- %d", [NSThread currentThread], i);
        });
    }
    
    NSLog(@"完成");
    
    // 运行结果等同于并发队列异步执行
    
    /*
     
     2016-02-23 15:47:06.044 YLDemo[29725:12689613] 开始
     2016-02-23 15:47:06.045 YLDemo[29725:12689613] 完成
     2016-02-23 15:47:06.045 YLDemo[29725:12689824] <NSThread: 0x7fe981532110>{number = 3, name = (null)} -- 0
     2016-02-23 15:47:06.045 YLDemo[29725:12689825] <NSThread: 0x7fe981710ad0>{number = 4, name = (null)} -- 2
     2016-02-23 15:47:06.045 YLDemo[29725:12690396] <NSThread: 0x7fe981705440>{number = 7, name = (null)} -- 4
     2016-02-23 15:47:06.045 YLDemo[29725:12689798] <NSThread: 0x7fe9816a4660>{number = 5, name = (null)} -- 3
     2016-02-23 15:47:06.045 YLDemo[29725:12690397] <NSThread: 0x7fe98345a560>{number = 6, name = (null)} -- 5
     2016-02-23 15:47:06.045 YLDemo[29725:12689799] <NSThread: 0x7fe981507210>{number = 2, name = (null)} -- 1
     2016-02-23 15:47:06.045 YLDemo[29725:12690398] <NSThread: 0x7fe9832051d0>{number = 8, name = (null)} -- 6
     2016-02-23 15:47:06.045 YLDemo[29725:12690399] <NSThread: 0x7fe983100300>{number = 9, name = (null)} -- 7
     2016-02-23 15:47:06.045 YLDemo[29725:12689824] <NSThread: 0x7fe981532110>{number = 3, name = (null)} -- 8
     2016-02-23 15:47:06.046 YLDemo[29725:12689825] <NSThread: 0x7fe981710ad0>{number = 4, name = (null)} -- 9
     
     */
}

#pragma mark 调度组
/**
 *  此示例展示了, 执行多个耗时操作, 所有的任务完成后, 会发出通知, 并在主线程内进行 UI 的更新操作
 */
- (void)GCD_test9
{
    // 创建一个调度组
    dispatch_group_t group = dispatch_group_create();
    
    // 创建一个全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 将3个下载任务添加到队列里
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"下载 --- 1 %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"下载 --- 2 %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"下载 --- 3 %@", [NSThread currentThread]);
    });
    
    // 调度组完成后会调用此消息通知, 可以跨队列通讯
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        NSLog(@"下载已全部完成  %@", [NSThread currentThread]);
    });
    
    /*
     
     2016-02-23 16:01:42.226 YLDemo[29908:12732803] 下载 --- 2 <NSThread: 0x7f94832213c0>{number = 2, name = (null)}
     2016-02-23 16:01:42.226 YLDemo[29908:12732818] 下载 --- 3 <NSThread: 0x7f9481d5c500>{number = 4, name = (null)}
     2016-02-23 16:01:42.226 YLDemo[29908:12732802] 下载 --- 1 <NSThread: 0x7f9481e390f0>{number = 3, name = (null)}
     2016-02-23 16:01:42.226 YLDemo[29908:12732522] 下载已全部完成  <NSThread: 0x7f9481d07ff0>{number = 1, name = main}
     
     */
}


#pragma mark - NSOperation

/**
 *  NSOperation 是对 GCD 的封装, NSOperation是一个抽象类, NSBlockOperation ,NSInvocationOperation 是NSOperation的子类, 任务一旦添加到队列中, 就会自动异步执行
 */
- (void)NSOperation
{
    // 创建操作队列, 相当于 GCD 中的并发异步队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 最大并发数, 指同时执行的操作的最大个数
    queue.maxConcurrentOperationCount = 2;
    
    // 创建操作任务1
    NSOperation *invocation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadImage) object:nil];
    
    // 创建操作任务2
    NSBlockOperation *block = [NSBlockOperation blockOperationWithBlock:^{
       
        NSLog(@"blcok operation -- %@", [NSThread currentThread]);
        [NSThread sleepForTimeInterval:1.0];
    }];
    
    // 添加依赖, 当invocation 执行完毕后, 再执行 blcok
    [block addDependency:invocation];
    
    // 将任务1.2添加到操作队列中
    [queue addOperation:invocation];
    [queue addOperation:block];
    
    // 也可以一次性添加多个任务, wait == YES, 表示前面执行完毕再执行后面的
//    [queue addOperations:@[invocation, block] waitUntilFinished:NO];
    
    // 直接添加操作任务
    [queue addOperationWithBlock:^{
       
        NSLog(@"第三种添加操作任务的方法 -- %@", [NSThread currentThread]);
        
        // 耗时操作, 延时2s
        [NSThread sleepForTimeInterval:2.0];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
           
            NSLog(@"%@ -- 在主线程更新 UI", [NSThread currentThread]);
        }];
    }];
    
//    queue.suspended = YES;  // 暂停队列里的任务, 当前正在执行的任务会继续执行完毕
//    [queue cancelAllOperations];    // 取消所有的任务, 不可恢复
    
    NSLog(@"完成");
    
    /*
     
     2016-02-23 22:00:14.502 YLDemo[31832:13026654] 完成
     2016-02-23 22:00:14.502 YLDemo[31832:13026939] 第三种添加操作任务的方法 -- <NSThread: 0x7f8ee0f2e820>{number = 2, name = (null)}
     2016-02-23 22:00:14.502 YLDemo[31832:13026963] invocation operation -- <NSThread: 0x7f8ee0c10c20>{number = 4, name = (null)}
     2016-02-23 22:00:15.577 YLDemo[31832:13026963] blcok operation -- <NSThread: 0x7f8ee0c10c20>{number = 4, name = (null)}
     2016-02-23 22:00:16.506 YLDemo[31832:13026654] <NSThread: 0x7f8ee0c05c70>{number = 1, name = main} -- 在主线程更新 UI
     
     */
}

- (void)downloadImage
{
    NSLog(@"invocation operation -- %@", [NSThread currentThread]);
    [NSThread sleepForTimeInterval:1.0];
}



@end
