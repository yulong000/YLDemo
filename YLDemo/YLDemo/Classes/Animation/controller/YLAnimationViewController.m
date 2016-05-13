//
//  YLAnimationViewController.m
//  YLDemo
//
//  Created by WYL on 16/1/13.
//  Copyright © 2016年 WYL. All rights reserved.
//

#import "YLAnimationViewController.h"

@interface YLAnimationViewController ()

@property (nonatomic, weak) UIImageView *testView;

@end

@implementation YLAnimationViewController
/*
 
 ---------------------------------------------------------------------------------------------------------------------------------
 CAAnimation ->     1.CAAnimationGroup              // 动画组, 一个layer设定了很多动画，他们都会同时执行
                    2.CAPropertyAnimation           // 属性动画 (使用子类创建对象)
                                ->>  1.CABasicAnimation          // 通过设定起始点，终点，时间，动画会沿着你这设定点进行移动。可以看做特殊的CAKeyFrameAnimation
                                            ->>>  1.CASpringAnimation     // 弹簧动画
                                ->>  2.CAKeyframeAnimation       // 可以通过设定CALayer的始点、中间关键点、终点的frame，时间，动画会沿你设定的轨迹进行移动
                    3.CATransition                  //  apple 封装好的动画
 ---------------------------------------------------------------------------------------------------------------------------------
 
 fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
 
 下面来讲各个fillMode的意义
 kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
 kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
 kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
 kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
 
 ---------------------------------------------------------------------------------------------------------------------------------
 
 UIView 动画属性
 常规动画属性设置（可以同时选择多个进行设置）
 
 UIViewAnimationOptionLayoutSubviews：动画过程中保证子视图跟随运动。
 
 UIViewAnimationOptionAllowUserInteraction：动画过程中允许用户交互。
 
 UIViewAnimationOptionBeginFromCurrentState：所有视图从当前状态开始运行。
 
 UIViewAnimationOptionRepeat：重复运行动画。
 
 UIViewAnimationOptionAutoreverse ：动画运行到结束点后仍然以动画方式回到初始点。
 
 UIViewAnimationOptionOverrideInheritedDuration：忽略嵌套动画时间设置。
 
 UIViewAnimationOptionOverrideInheritedCurve：忽略嵌套动画速度设置。
 
 UIViewAnimationOptionAllowAnimatedContent：动画过程中重绘视图（注意仅仅适用于转场动画）。
 
 UIViewAnimationOptionShowHideTransitionViews：视图切换时直接隐藏旧视图、显示新视图，而不是将旧视图从父视图移除（仅仅适用于转场动画）
 UIViewAnimationOptionOverrideInheritedOptions ：不继承父动画设置或动画类型。
 
 2.动画速度控制（可从其中选择一个设置）
 
 UIViewAnimationOptionCurveEaseInOut：动画先缓慢，然后逐渐加速。
 
 UIViewAnimationOptionCurveEaseIn ：动画逐渐变慢。
 
 UIViewAnimationOptionCurveEaseOut：动画逐渐加速。
 
 UIViewAnimationOptionCurveLinear ：动画匀速执行，默认值。
 
 3.转场类型（仅适用于转场动画设置，可以从中选择一个进行设置，基本动画、关键帧动画不需要设置）
 
 UIViewAnimationOptionTransitionNone：没有转场动画效果。
 
 UIViewAnimationOptionTransitionFlipFromLeft ：从左侧翻转效果。
 
 UIViewAnimationOptionTransitionFlipFromRight：从右侧翻转效果。
 
 UIViewAnimationOptionTransitionCurlUp：向后翻页的动画过渡效果。
 
 UIViewAnimationOptionTransitionCurlDown ：向前翻页的动画过渡效果。
 
 UIViewAnimationOptionTransitionCrossDissolve：旧视图溶解消失显示下一个新视图的效果。
 
 UIViewAnimationOptionTransitionFlipFromTop ：从上方翻转效果。
 
 UIViewAnimationOptionTransitionFlipFromBottom：从底部翻转效果。
 
 */


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Animation";
    
    UIImageView *testView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testView.contentMode = UIViewContentModeScaleAspectFit;
    testView.image = [UIImage imageNamed:@"1"];
    [self.view addSubview:testView];
    self.testView = testView;
    
    CGFloat h = 30;
    CGFloat y = self.view.frame.size.height - h;
    CGFloat w = self.view.frame.size.width / 5;
    NSArray *titleArr = @[@"basic", @"spring", @"keyframe", @"group", @"transition"];
    for(int i = 0; i < 5; i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(w * i, y, w, h)];
        btn.tag = i;
        btn.backgroundColor = [UIColor colorWithRed:(arc4random() % 220 + 30) / 255.0 green:(arc4random() % 220 + 30) / 255.0 blue:(arc4random() % 220 + 30) / 255.0 alpha:1.0];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)buttonClick:(UIButton *)btn
{
    [self.testView.layer removeAllAnimations];
    
    switch (btn.tag)
    {
        case 0:
            [self basicAnimation];
            break;
        case 1:
            [self springAnimation];
            break;
        case 2:
            [self keyframeAnimation];
            break;
        case 3:
            [self groupAnimation];
            break;
        case 4:
            [self transitionAnimation];
            break;
            
        default:
            break;
    }
}


- (void)basicAnimation
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath = @"transform.scale";
    basicAnimation.fromValue = @1.0;
    basicAnimation.toValue = @1.5;
    basicAnimation.duration = 1.0;
    basicAnimation.repeatCount = 3;
    basicAnimation.autoreverses = YES;       // 单次动画结束后, 会执行相反的动画 default no
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;        // 动画结束后, 保持结束后的状态, removedOnCompletion = NO 时有效
    [self.testView.layer addAnimation:basicAnimation forKey:@"basic"];
}

- (void)springAnimation
{
    CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"position.x"];
    springAnimation.mass = 1;             // 质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大,动画时间越长
    springAnimation.stiffness = 100;         // 刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快   default 100
    springAnimation.damping = 5;           // 阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快  default 10
    springAnimation.initialVelocity = -10;    // 初始速率，动画视图的初始速度大小,速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
    springAnimation.duration = springAnimation.settlingDuration;    // 根据当前的动画参数 返回弹簧动画到停止时的估算时间
    //    springAnimation.fromValue = @100;
    springAnimation.toValue = @300;
    //    springAnimation.autoreverses = YES;
    springAnimation.repeatCount = 3;
    springAnimation.removedOnCompletion = NO;   // 动画结束后 移除
    springAnimation.fillMode = kCAFillModeForwards;
    [self.testView.layer addAnimation:springAnimation forKey:@"spring"];
}

- (void)keyframeAnimation
{
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframeAnimation.values = @[[NSValue valueWithCGPoint:CGPointMake(100, 100)],
                                 [NSValue valueWithCGPoint:CGPointMake(100, 150)],
                                 [NSValue valueWithCGPoint:CGPointMake(100, 200)],
                                 [NSValue valueWithCGPoint:CGPointMake(150, 200)],
                                 [NSValue valueWithCGPoint:CGPointMake(200, 200)],
                                 [NSValue valueWithCGPoint:CGPointMake(200, 150)]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, CGRectMake(100, 100, 200, 200));
    //    keyframeAnimation.path = path;  // 动画的路径, 设置后会使values属性失效
    CGPathRelease(path);
    
    keyframeAnimation.keyTimes = @[@0, @0.1, @0.2, @0.7, @0.9, @1]; // 以 0 开始, 以 1 结束, 中间划分时间段, 代表动画执行的时长
    
    /*
     1 kCAMediaTimingFunctionLinear//线性
     2 kCAMediaTimingFunctionEaseIn//淡入
     3 kCAMediaTimingFunctionEaseOut//淡出
     4 kCAMediaTimingFunctionEaseInEaseOut//淡入淡出
     5 kCAMediaTimingFunctionDefault//默认
     */
    keyframeAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                          [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    /*
     1 const kCAAnimationLinear         // 线性动画, 属性值被用于提供定时器信息以生成动画。这些模式值让你最大化控制动画的定时器。
     2 const kCAAnimationDiscrete       // 离散动画, 该值将引起动画属性从一个关键帧跳到另一个没有任何补间动画的下一个关键帧。计算模式使用keyTimes属性值，但忽略timingFunctions属性
     3 const kCAAnimationPaced          // 节奏动画，属性值不依赖由keyTimes或timingFunctions属性提供的额外定时器值。相反，定时器值被隐式地计算以提供一个常速率动画
     4 const kCAAnimationCubic          // 曲线动画,属性值被用于提供定时器信息以生成动画。这些模式值让你最大化控制动画的定时器。
     5 const kCAAnimationCubicPaced     // 节奏动画，属性值不依赖由keyTimes或timingFunctions属性提供的额外定时器值。相反，定时器值被隐式地计算以提供一个常速率动画
     */
    keyframeAnimation.calculationMode = kCAAnimationLinear;
    keyframeAnimation.duration = 3;
    keyframeAnimation.removedOnCompletion = YES;
    keyframeAnimation.repeatCount = 1;
    keyframeAnimation.rotationMode = kCAAnimationRotateAuto;    // 根据path的方向旋转角度, 使layer与path保持方向一致
    [self.testView.layer addAnimation:keyframeAnimation forKey:@"keyframe"];
    
}

- (void)groupAnimation
{
    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    basic.fromValue = @0;
    basic.toValue = @(M_PI);
    basic.repeatCount = 2;
    //    basic.duration = 1;
    
    CASpringAnimation *spring = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    spring.fromValue = @1;
    spring.toValue = @1.5;
    spring.duration = spring.settlingDuration;
    spring.mass = 1;
    spring.stiffness = 100;
    spring.damping = 10;
    spring.initialVelocity = 1;
    spring.repeatCount = 3;
    spring.autoreverses = YES;
    
    CAKeyframeAnimation *keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyframe.rotationMode = kCAAnimationRotateAuto;
    CGMutablePathRef path = CGPathCreateMutable();
    //    CGPathAddEllipseInRect(path, NULL, CGRectMake(50, 100, 200, 100));
    CGPathAddRect(path, NULL, CGRectMake(50, 100, 200, 100));
    keyframe.path = path;
    CGPathRelease(path);
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 5;
    group.animations = @[basic, spring, keyframe];
    group.removedOnCompletion = YES;
    [self.testView.layer addAnimation:group forKey:@"group"];
}

- (void)transitionAnimation
{
    /*
     过渡效果
      fade     交叉淡化过渡(不支持过渡方向) kCATransitionFade
      push     新视图把旧视图推出去  kCATransitionPush
      moveIn   新视图移到旧视图上面   kCATransitionMoveIn
      reveal   将旧视图移开,显示下面的新视图  kCATransitionReveal
      cube     立方体翻滚效果
      oglFlip  上下左右翻转效果
      suckEffect   收缩效果，如一块布被抽走(不支持过渡方向)
      rippleEffect 滴水效果(不支持过渡方向)
      pageCurl     向上翻页效果
      pageUnCurl   向下翻页效果
      cameraIrisHollowOpen  相机镜头打开效果(不支持过渡方向)
      cameraIrisHollowClose 相机镜头关上效果(不支持过渡方向)
     */
    CATransition *trans = [CATransition animation];
    trans.type = @"pageCurl";
    trans.subtype = kCATransitionReveal;
    trans.duration = 1;
    trans.startProgress = 0.5;
    trans.endProgress = 0.8;
    [self.testView.layer addAnimation:trans forKey:@"transition"];
}


@end
