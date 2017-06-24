//
//  MineCell.m
//  扫雷
//
//  Created by 刘国靖 on 15/2/14.
//  Copyright (c) 2015年 刘国靖. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRect:CGRectMake(2, 2, frame.size.width-4, frame.size.width-4)];
        shapeLayer.path = bezierPath.CGPath;
        shapeLayer.lineWidth = 1.0;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.fillColor = [UIColor colorWithRed:242.0/255.0 green:165.0/255.0 blue:31.0/255.0 alpha:1.0].CGColor;
        [self.contentView.layer addSublayer:shapeLayer];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.textLabel];
        
        
        
        self.maskView = [[UIView alloc] initWithFrame:self.textLabel.frame];
        self.maskView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.maskView];
        self.maskView.layer.cornerRadius = 3.0;
        self.maskView.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.maskView.layer.borderWidth = 1.0;
        
    }
    return self;
}


@end
