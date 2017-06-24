//
//  MineModel.m
//  扫雷
//
//  Created by 刘国靖 on 15/2/14.
//  Copyright (c) 2015年 刘国靖. All rights reserved.
//

#import "MineModel.h"

@implementation MineModel

- (id)init
{
    self = [super init];
    if (self) {
        self.isSelected = NO;
        self.isMine = NO;
        self.mineNumber = 0;
    }
    return self;
}


@end
