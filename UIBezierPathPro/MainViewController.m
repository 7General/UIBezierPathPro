//
//  MainViewController.m
//  UIBezierPathPro
//
//  Created by 王会洲 on 16/12/21.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "MainViewController.h"
#import "BasicView.h"
#import "CartogrameView.h"
#import "CreatePro.h"




#import "TestCreate.h"

@interface MainViewController ()
{
    CALayer *_tempLayer;//数据展示的折线图层
}

/**初始化*/
@property (nonatomic, strong) BasicView * basicViewSteup;
/**动画画折线图*/
@property (nonatomic, strong) CartogrameView * CartViewSteup;


@property (nonatomic, strong) CreatePro * motoView;

@property (nonatomic, strong) TestCreate * testView;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**画折线图*/
    //self.basicViewSteup = [[BasicView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 400)];
    //[self.view addSubview:self.basicViewSteup];
    
    //self.CartViewSteup = [[CartogrameView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 400)];
    //[self.view addSubview:self.CartViewSteup];
    /**动画绘制线路*/
    //[self drawBrokenLine];
    //[self drawLayerPoint];
    
    BOOL flag = NO;
    if(flag){
        self.motoView = [[CreatePro alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
        self.motoView.backgroundColor = [UIColor blueColor];
        [self.view addSubview:self.motoView];
    }else{
        self.testView = [[TestCreate alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 400)];
        self.testView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:self.testView];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 传入百分比的时候，传入 小数，  0.1 - 1 范围内  <==>  1 - 100
//    self.motoView.percent = arc4random_uniform(100 + 1) * 0.01;
    
    self.testView.percent = 0.8;//arc4random_uniform(100 + 1) * 0.01;
}


-(void)drawLayerPoint{
    
    CALayer * basLayer = [CALayer layer];
    basLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 400);
    basLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.view.layer addSublayer:basLayer];
    
    
    [self drawCirile:CGPointMake(24, 150) layer:basLayer color:[UIColor redColor]];
    [self drawCirile:CGPointMake(45, 20) layer:basLayer color:[UIColor redColor]];
    [self drawCirile:CGPointMake(60,90) layer:basLayer color:[UIColor redColor]];
    [self drawCirile:CGPointMake(85,25) layer:basLayer color:[UIColor redColor]];
    [self drawCirile:CGPointMake(100,10) layer:basLayer color:[UIColor redColor]];
    [self drawCirile:CGPointMake(125,80) layer:basLayer color:[UIColor redColor]];
    [self drawCirile:CGPointMake(140,100) layer:basLayer color:[UIColor redColor]];
    [self drawCirile:CGPointMake(165,19) layer:basLayer color:[UIColor redColor]];
    [self drawCirile:CGPointMake(280,150) layer:basLayer color:[UIColor redColor]];
    
    UIBezierPath * path = [[UIBezierPath alloc] init];
    CAShapeLayer * shapLayer = [[CAShapeLayer alloc] init];
    // 折线的颜色
    shapLayer.strokeColor = [UIColor blueColor].CGColor;
    // 填充颜色
    shapLayer.fillColor = [UIColor greenColor].CGColor;
    shapLayer.lineWidth = 1;
    [basLayer addSublayer:shapLayer];
    
    [path moveToPoint:CGPointMake(24, 150)];
    [path addLineToPoint:CGPointMake(45, 20)];
    [path addLineToPoint:CGPointMake(60, 90)];
    [path addLineToPoint:CGPointMake(85, 25)];
    [path addLineToPoint:CGPointMake(100, 10)];
    [path addLineToPoint:CGPointMake(125, 80)];
    [path addLineToPoint:CGPointMake(140, 100)];
    [path addLineToPoint:CGPointMake(165, 19)];
    [path addLineToPoint:CGPointMake(280, 150)];
    
    shapLayer.path = path.CGPath;
    
    //折线的绘制动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 2.0;
    [shapLayer addAnimation:animation forKey:nil];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    //    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //    // 颜色填充
    //    CGContextAddPath(ctx, path.CGPath);
    //    CGContextSetRGBFillColor(ctx,215.0/255.0, 236.0/255.0, 177.0/255.0, 1.0);
    //    CGContextFillPath(ctx);
}

- (void)drawBrokenLine{
    
    NSArray *numberArr = @[@-10,@0,@10,@20,@30,@40,@20,@30,@0,@30,@40,@-10,@20,@0,];
    CGFloat originY = 0;
    CGFloat originX = 0;//第一条竖线的横坐标
    CGFloat height = self.CartViewSteup.bounds.size.height;//表格的总高度
    CGFloat width = (self.view.bounds.size.width)/13;//两竖线之间的间距
    CGFloat space = height / 50;//每°代表的高度
    UIColor *roomColor = [UIColor redColor];
    _tempLayer = [CALayer layer];
    _tempLayer.position = CGPointMake(self.CartViewSteup.bounds.size.width/2, self.CartViewSteup.bounds.size.height/2);
    _tempLayer.bounds = CGRectMake(0, 0,self.CartViewSteup.bounds.size.width, self.CartViewSteup.bounds.size.height);
    _tempLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.CartViewSteup.layer addSublayer:_tempLayer];
    
    UIBezierPath *roomPath= [UIBezierPath bezierPath];
    CAShapeLayer *roomLine = [[CAShapeLayer alloc] init];
    // 填充色
    roomLine.strokeColor = roomColor.CGColor;
    // 区域填充
    roomLine.fillColor = [UIColor clearColor].CGColor;
    roomLine.lineWidth = 1;
    [_tempLayer addSublayer:roomLine];
    
    BOOL firstOfRoom = YES;
    for (int i = 0; i < 14; i ++) {
        int value = [numberArr[i] intValue];
        CGPoint roomCenter = CGPointMake(originX + width * i, originY+height-space*(value+10));
        [self drawCirile:roomCenter layer:_tempLayer color:roomColor];
        if (firstOfRoom){
            [roomPath moveToPoint:roomCenter];
            firstOfRoom = NO;
        }else{
            [roomPath addLineToPoint:roomCenter];
        }
    }
    roomLine.path = roomPath.CGPath;
    
    //折线的绘制动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.duration = 2.0;
    [roomLine addAnimation:animation forKey:nil];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
}

- (void)drawCirile:(CGPoint)center layer:(CALayer *)layer color:(UIColor *)color
{
    CALayer *roomCirile = [CALayer layer];
    roomCirile.position = center;
    roomCirile.bounds = CGRectMake(0, 0, 6, 6);
    roomCirile.cornerRadius = 3;
    roomCirile.masksToBounds = YES;
    roomCirile.backgroundColor = color.CGColor;
    [layer addSublayer:roomCirile];
}


@end
