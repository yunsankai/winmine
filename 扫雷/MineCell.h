//
//  MineCell.h
//  扫雷
//
//  Created by 刘国靖 on 15/2/14.
//  Copyright (c) 2015年 刘国靖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCell : UICollectionViewCell

@property(nonatomic,strong)UILabel *textLabel;

@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)CAShapeLayer *shapeLayer;
@end
