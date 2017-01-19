//
//  CartogrameView.m
//  UIBezierPathPro
//
//  Created by 王会洲 on 16/12/21.
//  Copyright © 2016年 王会洲. All rights reserved.
//

#import "CartogrameView.h"

@interface CartogrameView()
@property (nonatomic, strong) NSMutableArray * myDates;
@end

@implementation CartogrameView

-(NSMutableArray *)myDates{
    if (_myDates == nil) {
        _myDates = [NSMutableArray array];
    }
    return _myDates;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initData];
    }
    return self;
}
-(void)initView {
    self.backgroundColor = [UIColor lightGrayColor];
}
-(void)initData {
    [self.myDates addObject:@"12.10"];
    [self.myDates addObject:@"12.20"];
    [self.myDates addObject:@"12.30"];
    [self.myDates addObject:@"12.40"];
    [self.myDates addObject:@"12.50"];
    [self.myDates addObject:@"13.00"];
    [self.myDates addObject:@"13.10"];
    [self.myDates addObject:@"13.20"];
}


-(void)drawRect:(CGRect)rect {

}

@end
