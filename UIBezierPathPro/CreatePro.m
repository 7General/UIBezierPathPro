//
//  CreatePro.m
//  UIBezierPathPro
//
//  Created by 王会洲 on 16/12/22.
//  Copyright © 2016年 王会洲. All rights reserved.
//

//把角度转换成PI的方式
#define degreesToRadians(x) (M_PI*(x)/180.0)

#import "CreatePro.h"

static CGFloat  lineWidth = 25;   // 线宽

static CGFloat  progressLineWidth = 3;  // 外圆进度的线宽



@interface CreatePro()
/** 外圆的底层layer*/
@property (nonatomic,strong) CAShapeLayer * bottomShapeLayer;
@property (nonatomic,strong)CAShapeLayer * upperShapeLayer;  // 外圆的更新的layer
@property (nonatomic,strong)CAGradientLayer * gradientLayer;  // 外圆的颜色渐变layer

@property (nonatomic,strong)UILabel *progressView;  //  进度文字

/**中心点 x*/
@property (nonatomic,assign)CGFloat centerX;
/**中心点 y*/
@property (nonatomic,assign)CGFloat centerY;
@property (nonatomic,assign)CGFloat startAngle;  // 开始的弧度
@property (nonatomic,assign)CGFloat endAngle;  // 结束的弧度
/**开始角度*/
@property (nonatomic,assign)CGFloat radius;
/**外层开始角度*/
@property (nonatomic, assign) CGFloat progressRadius;



@property (nonatomic,strong)CAShapeLayer *progressBottomLayer; // 底部进度条的layer
@property (nonatomic,strong)CAShapeLayer *progressLayer;  // 小的进度progressLayer
@property (nonatomic,strong)CAGradientLayer *progressGradientLayer; // 小的进度渐变颜色


@property (nonatomic,assign) int ratio;  // 记录百分比 用于数字跳动
@end

@implementation CreatePro
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
    self.radius = (self.bounds.size.width - 100 - 25) / 2;  // 内圆的角度
    self.progressRadius = (self.bounds.size.width - 100 - 3 + 30) / 2; // 外圆的角度

//    [self drawButtonLayer];
//    [self drawUpperLayer];
//    [self drawGradientLayer];
//    [self.bottomShapeLayer addSublayer:self.gradientLayer];
//    [self.gradientLayer setMask:self.upperShapeLayer];
//    [self.layer addSublayer:self.bottomShapeLayer];
    
    [self drawProgressBottomLayer];
    [self drawProgressLayer];
    [self drawProgressGradientLayer];
    
    [self.progressBottomLayer addSublayer:self.progressGradientLayer];  // 把更新的layer 添加到 底部的layer 上
    [self.progressGradientLayer setMask:self.progressLayer]; // 设置渐变色的蒙版为更新的layer
    [self.layer addSublayer:self.progressBottomLayer ];  // 把bottomlayer 加到自己的layer 上
    
    
    [self addSubview:self.progressView];
}

- (UILabel *)progressView
{
    if (!_progressView) {
        
        _progressView = [[UILabel alloc]init];
        
        CGFloat width = 160;
        CGFloat height = 60;
        _progressView.frame = CGRectMake((self.frame.size.width - width) / 2, _centerY - height / 2, width, height);
        _progressView.font = [UIFont systemFontOfSize:60];
        //        _progressView.backgroundColor = [UIColor greenColor];
        _progressView.textAlignment = NSTextAlignmentCenter;
        _progressView.textColor = [UIColor whiteColor];
        _progressView.text = @"0%";
    }
    
    return _progressView;
}



/**绘制外援的底层的layer*/
-(void)drawButtonLayer {
    self.bottomShapeLayer  = [[CAShapeLayer alloc] init];
    self.bottomShapeLayer.frame  = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.centerX, self.centerY) radius:self.radius startAngle:degreesToRadians(self.startAngle) endAngle:degreesToRadians(self.endAngle) clockwise:YES];

    self.bottomShapeLayer.path = path.CGPath;
    self.bottomShapeLayer.lineCap = kCALineCapButt;
    // 第一个参数为线的宽度  第二个参数线的间距
    self.bottomShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:10], nil];
    // 外圈线条宽度
    self.bottomShapeLayer.lineWidth = lineWidth;
    // 外圈线条颜色
    self.bottomShapeLayer.strokeColor  = [UIColor lightGrayColor].CGColor;
    // 外圈包含圈内的填充颜色
    self.bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
}
/**绘制外圆的更新的layer*/
-(void)drawUpperLayer {
    self.upperShapeLayer  = [[CAShapeLayer alloc] init];
    self.upperShapeLayer.frame  = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius  startAngle:degreesToRadians(self.startAngle) endAngle:degreesToRadians(self.endAngle) clockwise:YES];
    self.upperShapeLayer.path = path.CGPath;
    self.upperShapeLayer.strokeStart = 0;
    self.upperShapeLayer.strokeEnd =   0;
    //    [self performSelector:@selector(shapeChange) withObject:nil afterDelay:0.3];
    self.upperShapeLayer.lineWidth = lineWidth;
    self.upperShapeLayer.lineCap = kCALineCapButt;
    self.upperShapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:10], nil];
    self.upperShapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.upperShapeLayer.fillColor = [UIColor clearColor].CGColor;
}

//  绘制渐变色的layer
- (void)drawGradientLayer {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_centerX, _centerY) radius:_radius  startAngle:degreesToRadians(self.startAngle) endAngle:degreesToRadians(self.endAngle) clockwise:YES];
    
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)[UIColor greenColor].CGColor,(id)[UIColor whiteColor].CGColor,(id)[UIColor purpleColor].CGColor,(id)[UIColor redColor].CGColor, nil];
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.shadowPath = path.CGPath;
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.startPoint = CGPointMake(0, 1);
    self.gradientLayer.endPoint = CGPointMake(1, 0);
    [self.gradientLayer setColors:colors];
}

// 绘制外圆的底层layer
- (void)drawProgressBottomLayer{
    self.progressBottomLayer = [[CAShapeLayer alloc] init];
    self.progressBottomLayer.frame  = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.centerX, self.centerY) radius:self.progressRadius  startAngle:degreesToRadians(self.startAngle) endAngle:degreesToRadians(self.endAngle - 5) clockwise:YES];
    _progressBottomLayer.path = path.CGPath;

#pragma mark - 线段的开头为圆角
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

#pragma mark - 如果想显示为齿轮状态，则打开这段代码
    //    _progressLayer.lineCap = kCALineCapButt;
    //    _progressLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:5], nil];
#pragma mark - 线段的开头为圆角
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
//        [_progressGradientLayer setLocations:@[@0.2, @0.5, @0.7, @1]];
    [self.progressGradientLayer setStartPoint:CGPointMake(0, 1)];
    [self.progressGradientLayer setEndPoint:CGPointMake(1, 0)];

}



@synthesize percent = _percent;
- (CGFloat )percent
{
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
    _upperShapeLayer.strokeEnd = 0 ;
    _progressLayer.strokeEnd = 0 ;
    [CATransaction commit];
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [CATransaction setAnimationDuration:2.f];
    _upperShapeLayer.strokeEnd = _percent;;
    _progressLayer.strokeEnd = _percent;;
    [CATransaction commit];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:_percent * 0.02 target:self selector:@selector(updateLabl:) userInfo:nil repeats:YES];
}

- (void)updateLabl:(NSTimer *)sender {
    static int flag = 0;
    if (flag   == self.ratio) {
        [sender invalidate];
        sender = nil;
        self.progressView.text = [NSString stringWithFormat:@"%d%%",flag];
        flag = 0;
    }
    else{
        self.progressView.text = [NSString stringWithFormat:@"%d%%",flag];
    }
    flag ++;
}




@end
