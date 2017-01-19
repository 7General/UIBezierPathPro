//
//  TestCreate.m
//  UIBezierPathPro
//
//  Created by 王会洲 on 16/12/22.
//  Copyright © 2016年 王会洲. All rights reserved.
//

//把角度转换成PI的方式
#define degreesToRadians(x) (M_PI*(x)/180.0)

#import "TestCreate.h"

static CGFloat  lineWidth = 25;   // 线宽
static CGFloat  progressLineWidth = 3;  // 外圆进度的线宽

@interface TestCreate()
@property (nonatomic,strong)CAShapeLayer *progressBottomLayer; // 底部进度条的layer
@property (nonatomic,strong)CAShapeLayer *progressLayer;  // 小的进度progressLayer
@property (nonatomic,strong)CAGradientLayer *progressGradientLayer; // 小的进度渐变颜色


/**中心点 x*/
@property (nonatomic,assign)CGFloat centerX;
/**中心点 y*/
@property (nonatomic,assign)CGFloat centerY;
@property (nonatomic,assign)CGFloat startAngle;  // 开始的弧度
@property (nonatomic,assign)CGFloat endAngle;  // 结束的弧度

/**外层开始角度*/
@property (nonatomic, assign) CGFloat progressRadius;

@property (nonatomic,assign) int ratio;  // 记录百分比 用于数字跳动
@end
@implementation TestCreate

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView {
    self.startAngle = -220;  // 启始角度
    self.endAngle = 45;  // 结束角度
    
    self.centerX = self.frame.size.width * 0.5;
    self.centerY = self.frame.size.height * 0.5;
    self.progressRadius = (self.bounds.size.width - 100 - 3 + 30) / 2; // 外圆的角度
    
    // 画最外面的进度弧度线
    [self drawProgressBottomLayer];
    [self drawProgressLayer];
    [self drawProgressGradientLayer];
    [self.progressBottomLayer addSublayer:self.progressGradientLayer]; // 把更新的layer 添加到 底部的layer 上
    [self.progressGradientLayer setMask:self.progressLayer]; // 设置渐变色的蒙版为更新的layer
    [self.layer addSublayer:self.progressBottomLayer];// 把bottomlayer 加到自己的layer 上
}


// 绘制外圆的底层layer
- (void)drawProgressBottomLayer{
    self.progressBottomLayer = [[CAShapeLayer alloc] init];
    self.progressBottomLayer.frame  = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.centerX, self.centerY) radius:self.progressRadius  startAngle:degreesToRadians(self.startAngle) endAngle:degreesToRadians(self.endAngle - 5) clockwise:YES];
    self.progressBottomLayer.path = path.CGPath;
    self.progressBottomLayer.lineCap = kCALineCapRound;
    self.progressBottomLayer.lineWidth = 3;
    self.progressBottomLayer.strokeColor = [UIColor clearColor].CGColor;
    self.progressBottomLayer.fillColor = [UIColor clearColor].CGColor;
}


// 绘制外圆的更新的layer
- (void)drawProgressLayer {
    self.progressLayer = [[CAShapeLayer alloc] init];
    self.progressLayer.frame = self.bounds;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY ) radius:_progressRadius  startAngle:degreesToRadians(_startAngle) endAngle:degreesToRadians(_endAngle - 5)  clockwise:YES];
    self.progressLayer.path = bezierPath.CGPath;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd =   0;
    //    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0.3];
    self.progressLayer.lineWidth = 3;
    self.progressLayer.lineCap = kCALineCapRound;
    self.progressLayer.strokeColor = [UIColor blueColor].CGColor;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
}

//  绘制渐变色
- (void)drawProgressGradientLayer {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.centerX, self.centerY ) radius:self.progressRadius  startAngle:degreesToRadians(self.startAngle)  endAngle:degreesToRadians(self.endAngle - 5)  clockwise:YES];
    self.progressGradientLayer = [CAGradientLayer layer];
    self.progressGradientLayer.frame = self.bounds;
    self.progressLayer.shadowPath = bezierPath.CGPath;
    self.progressGradientLayer.colors =  [NSMutableArray arrayWithObjects:(id)[UIColor greenColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor purpleColor].CGColor,(id)[UIColor redColor].CGColor, nil];
    [self.progressGradientLayer setStartPoint:CGPointMake(0, 1)];
    [self.progressGradientLayer setEndPoint:CGPointMake(1, 0)];
}





@synthesize percent = _percent;
- (CGFloat )percent {
    return _percent;
}
- (void)setPercent:(CGFloat)percent {
    _percent = percent;
    if (percent > 1) {
        percent = 1;
    }else if (percent < 0){
        percent = 0;
    }
    self.ratio = percent * 100;
    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0];
}

- (void)shapeChange {
    // 复原
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:0];
    self.progressLayer.strokeEnd = 0 ;
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:2.f];
    self.progressLayer.strokeEnd = _percent;;
    [CATransaction commit];
    //NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_percent * 0.02 target:self selector:@selector(updateLabl:) userInfo:nil repeats:YES];
}

//- (void)updateLabl:(NSTimer *)sender {
//    static int flag = 0;
//    if (flag   == self.ratio) {
//        [sender invalidate];
//        sender = nil;
//        self.progressView.text = [NSString stringWithFormat:@"%d%%",flag];
//        flag = 0;
//    }
//    else{
//        self.progressView.text = [NSString stringWithFormat:@"%d%%",flag];
//    }
//    flag ++;
//}



@end
