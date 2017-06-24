//
//  MineModel.h
//  扫雷
//
//  Created by 刘国靖 on 15/2/14.
//  Copyright (c) 2015年 刘国靖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineModel : NSObject

//是否已经被揭开
@property(nonatomic,assign)BOOL isSelected;

//是否是雷，
@property(nonatomic,assign)BOOL isMine;

//雷个数
@property(nonatomic,assign)NSInteger mineNumber;

//@property(nonatomic,assign)NSInteger mineID;

//位置
@property(nonatomic,strong)NSIndexPath *indexPath;
@end
