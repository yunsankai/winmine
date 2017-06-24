//
//  ViewController.m
//  扫雷
//
//  Created by 刘国靖 on 15/2/14.
//  Copyright (c) 2015年 刘国靖. All rights reserved.
//81 - 10          256 - 40     60列32行-192

//10雷-9行 ---------40雷16行
//#define kRow 9

//#define kLine 17

//#define kMine 25


//#define kBoxWidth 30

typedef enum direction{
    kDirectionLeftUp = 1,
    kDirectionUp = 2,
    kDirectionRightUp = 3,
    kDirectionLeft = 4,
    kDirectionRight = 5,
    kDirectionLeftDown = 6,
    kDirectionDown = 7,
    kDirectionRightDown = 8
}kDirection;

#import "ViewController.h"
#import "MineCell.h"
#import "MineModel.h"


@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>{
    NSInteger useTime;
    NSTimer *timer;
    NSInteger kBoxWidth;
    NSInteger kRow;
    NSInteger kLine;
    NSInteger kMine;
    
}

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@property(nonatomic,strong)NSArray *directionArray;

@property(nonatomic,assign)NSInteger currentLevel;
//@property(nonatomic,strong)NSArray *

@end

@implementation ViewController

- (void)setCurrentLevel:(NSInteger)currentLevel
{
    _currentLevel = currentLevel;
    switch (_currentLevel) {
        case 0:
            kRow = 9/2;
            kLine = 17/2;
            kMine = 25/3;
            break;
        case 1:
            kRow = 9;
            kLine = 17;
            kMine = 25;
            break;
        case 2:
            kRow = 9*1.5;
            kLine = 17*1.5;
            kMine = 25*1.5;
            break;
        default:
            break;
    }
    
    [self relayoutCollectionView];
    [self reloadContentAndMine];
}

- (void)relayoutCollectionView
{
    kBoxWidth = self.view.frame.size.width/kLine - 1;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(kBoxWidth, kBoxWidth);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    [self.collectionView setCollectionViewLayout:flowLayout animated:YES];
    
}

- (void)choiceLevelBtnClicked:(UIButton *)btn
{
    self.currentLevel = btn.tag;
}

- (void)customBtnClicked
{
    /*
     kRow = 9;
     
     kLine = 17;
     
     kMine = 25;
     */
    UITextField *rowField = [self.view viewWithTag:3];
    UITextField *lineField = [self.view viewWithTag:4];
    UITextField *mineField = [self.view viewWithTag:5];
    NSInteger row = (rowField.text.length > 0)?rowField.text.integerValue:rowField.placeholder.integerValue;
    NSInteger line = (lineField.text.length > 0)?lineField.text.integerValue:lineField.placeholder.integerValue;
    NSInteger mine = (mineField.text.length > 0)?mineField.text.integerValue:mineField.placeholder.integerValue;
    
    if (row > 0 && line > 0 && mine > 0 && row*line > mine) {
        kRow = row;
        
        kLine = line;
        
        kMine = mine;
        [self relayoutCollectionView];
        [self reloadContentAndMine];
    }
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *btnTitles = @[@"初级",@"中级",@"高级"];
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(50*i, 0, 50, 20);
        btn.tag = i;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(choiceLevelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    NSArray *placeHolders = @[@"9",@"17",@"25"];
    for (int i = 0; i < 3; i++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(150+50*i, 0, 50, 20)];
        textField.placeholder = placeHolders[i];
        textField.tag = 3+i;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:textField];
    }
    
    UIButton *sureCustomBtn = [[UIButton alloc] initWithFrame:CGRectMake(300, 0, 50, 20)];
    [sureCustomBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureCustomBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureCustomBtn addTarget:self action:@selector(customBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureCustomBtn];
    
    //中级，
    kRow = 9;
    
    kLine = 17;
    
    kMine = 25;
    
    
    
    kBoxWidth = self.view.frame.size.width/kLine - 1;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(kBoxWidth, kBoxWidth);
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MineCell class] forCellWithReuseIdentifier:@"MineCell"];
    [self.view addSubview:self.collectionView];
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    [self reloadContentAndMine];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 1; i < 9; i++) {
        [tempArray addObject:@(i)];
    }
    self.directionArray = [NSArray arrayWithArray:tempArray];
    
}
#pragma mark ------------------------UICollectionDatasourceDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    return self.dataSourceArray.count;
    return kRow;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    NSArray *rowArray = [self.dataSourceArray objectAtIndex:section];
//    return rowArray.count;
    return kLine;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MineCell" forIndexPath:indexPath];
    NSArray *rowArray = [self.dataSourceArray objectAtIndex:indexPath.section];
    MineModel *model = [rowArray objectAtIndex:indexPath.row];
//    if (model.isMine) {
//         cell.textLabel.text = @"*";
//        cell.maskView.hidden = YES;
//    }else{
//        if (model.mineNumber > 0) {
//            cell.textLabel.text = [NSString stringWithFormat:@"%ld",model.mineNumber];
//        }else{
//            cell.textLabel.text = @"";
//        }
//    }
    
    if (model.isSelected == YES) {
        cell.maskView.hidden = YES;
    }else{
        cell.maskView.hidden = NO;
    }
    cell.maskView.hidden = NO;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *rowArray = [self.dataSourceArray objectAtIndex:indexPath.section];
    MineModel *model = [rowArray objectAtIndex:indexPath.row];
    if (model.isMine) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"游戏结束" message:@"是否重新开始" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        MineCell *cell = (MineCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.maskView.hidden = YES;
        if (model.isSelected == NO) {
            model.isSelected = YES;
            
            if (model.isMine == NO) {
                if (model.mineNumber > 0) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld",model.mineNumber];
                }else{
                    cell.textLabel.text = @"";
                }
                if (model.mineNumber == 0) {
                    [self findEnmptyCellIndexPath:indexPath];
                }
                
            }
//            NSLog(@"circletimes is %d",circleTimes);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.collectionView reloadData];
//            });
        }
        
        [self finishedSweep];
    }
}
- (void)finishedSweep
{
    NSInteger hasSweepedNumber = 0;
    for (int i = 0; i < self.dataSourceArray.count; i++) {
        NSMutableArray *rowArray = [self.dataSourceArray objectAtIndex:i];
        for (int j = 0; j < rowArray.count; j++) {
            MineModel *model = [rowArray objectAtIndex:j];
            if (model.isMine == NO && model.isSelected == YES) {
                hasSweepedNumber ++;
            }
        }
    }
    if ((kRow*kLine - hasSweepedNumber) <= kMine) {
        //自定义不记录最佳时间
        if (_currentLevel <= 2) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSInteger bestUseTime = [userDefaults integerForKey:[NSString stringWithFormat:@"UseTime_%zd",_currentLevel]];
            if (bestUseTime == 0 || useTime < bestUseTime) {
                [userDefaults setInteger:useTime forKey:[NSString stringWithFormat:@"UseTime_%zd",_currentLevel]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你赢了？" message:[NSString stringWithFormat:@"破纪录了！\n用时：%lds",useTime] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你赢了？" message:[NSString stringWithFormat:@"用时：%lds",useTime] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你赢了？" message:[NSString stringWithFormat:@"用时：%lds",useTime] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self reloadContentAndMine];
}
//递归查找所有的空得CEll --- 并将他们置为选中状态
- (void)findEnmptyCellIndexPath:(NSIndexPath*)indexPath
{
//    MineModel *currentModel = [[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    for (int i = 0; i < self.directionArray.count; i++) {
        NSInteger direction = [[self.directionArray objectAtIndex:i] integerValue];
        MineModel *model = [self findEightDirictionCellIndexPath:indexPath direction:direction];
        if (model) {
            if (model.isMine==NO && model.mineNumber==0) {
                if(model.isSelected == NO){
                    model.isSelected = YES;
//                    dispatch_async(dispatch_get_global_queue(1, 0), ^{
                       [self findEnmptyCellIndexPath:model.indexPath];
//                    });
                }
            }else{
                model.isSelected = YES;
            }
            if (model.isMine == NO) {
                MineCell *cell = (MineCell*)[self.collectionView cellForItemAtIndexPath:model.indexPath];
                cell.maskView.hidden = YES;
                if (model.mineNumber > 0) {
                    cell.textLabel.text = [NSString stringWithFormat:@"%ld",model.mineNumber];
                }else{
                    cell.textLabel.text = @"";
                }
            }
        }
    }
}

- (MineModel*)findEightDirictionCellIndexPath:(NSIndexPath*)indexPath direction:(NSInteger)direction
{
    NSIndexPath *targetIndexPath = nil;
    NSArray *upArray = nil;
    NSArray *rowArray = [self.dataSourceArray objectAtIndex:indexPath.section];
    NSArray *downArray = nil;
    if (indexPath.section > 0) {
        upArray = [self.dataSourceArray objectAtIndex:indexPath.section-1];
    }
    if (indexPath.section < (self.dataSourceArray.count-1)) {
        downArray = [self.dataSourceArray objectAtIndex:indexPath.section+1];
    }
    switch (direction) {
        case kDirectionLeftUp:
            if (indexPath.section > 0 && indexPath.row > 0) {
                targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section-1];
            }
            break;
        case kDirectionUp:
            if (indexPath.section > 0) {
                targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
            }
            break;
        case kDirectionRightUp:
            if (indexPath.section > 0 && indexPath.row < (upArray.count-1)) {
                targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section-1];
            }
            break;
        case kDirectionLeft:
            if (indexPath.row > 0) {
                targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
            }
            break;
        case kDirectionRight:
            if (indexPath.row < (rowArray.count-1)) {
                targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
            }
            break;
        case kDirectionLeftDown:
            if (indexPath.section < (self.dataSourceArray.count-1) && indexPath.row > 0) {
                targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section+1];
            }
            break;
        case kDirectionDown:
            if (indexPath.section < (self.dataSourceArray.count-1)) {
                targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
            }
            break;
        case kDirectionRightDown:
            if (indexPath.section < (self.dataSourceArray.count-1) && indexPath.row < (downArray.count-1)) {
                targetIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section+1];
            }
            break;
        default:
            break;
    }
    MineModel *model = nil;
    if (targetIndexPath) {
        model = [[self.dataSourceArray objectAtIndex:targetIndexPath.section] objectAtIndex:targetIndexPath.row];
        model.indexPath = targetIndexPath;
    }
    return model;
}
- (void)reloadContentAndMine
{
    //随机 数据 设置数目----填充二维数组
    self.dataSourceArray = [NSMutableArray array];
    for (int i = 0; i < kRow; i++) {
        NSMutableArray *lineArray = [NSMutableArray array];
        for (int j = 0; j < kLine; j++) {
            MineModel *mineModel = [MineModel new];
//            mineModel.mineID = i*10 + j;
            [lineArray addObject:mineModel];
        }
        [self.dataSourceArray addObject:lineArray];
    }
    
    //随机雷
//    BOOL needContinue = YES;
    NSMutableArray *IDarray = [NSMutableArray array];
    for (int i = 0; i < kRow; i++) {
        NSMutableArray *lineArray = [NSMutableArray array];
        for (int j = 0; j < kLine; j++) {
            NSString *idString = [NSString stringWithFormat:@"%d-%d",i,j];
            [lineArray addObject:idString];
        }
        [IDarray addObject:lineArray];
    }
    for (int i = 0; i < kMine; i++) {
        NSInteger randomRow = arc4random()%IDarray.count;
        NSMutableArray *rowArray = [IDarray objectAtIndex:randomRow];
        NSInteger randomLine = arc4random()%rowArray.count;
        NSString *idString = [rowArray objectAtIndex:randomLine];
        NSArray *tempArray = [idString componentsSeparatedByString:@"-"];
        NSInteger indexI = [[tempArray firstObject]integerValue];
        NSInteger indexJ = [[tempArray lastObject]integerValue];
        MineModel *model = [[self.dataSourceArray objectAtIndex:indexI] objectAtIndex:indexJ];
        model.isMine = YES;
        [rowArray removeObjectAtIndex:randomLine];
    }
    
    
    for (int i = 0 ; i < self.dataSourceArray.count; i++) {
        NSArray *rowArray = [self.dataSourceArray objectAtIndex:i];
        for (int j = 0; j < rowArray.count; j++) {
            MineModel *model = [rowArray objectAtIndex:j];
            if (model.isMine == YES) {
                printf("*");
            }else{
                printf("%ld",(long)model.mineNumber);
            }
        }
        printf("\n");
    }
//    while (needContinue) {
//        
//        //检查雷的个数，如果大于等于40 随机结束
//        NSInteger mineNumber = 0;
//        for (int i = 0; i < self.dataSourceArray.count; i++) {
//            NSMutableArray *rowArray = [self.dataSourceArray objectAtIndex:i];
//            for (int j = 0; j < rowArray.count; j++) {
//                MineModel *model = [rowArray objectAtIndex:j];
//                if (model.isMine) {
//                    mineNumber ++;
//                }
//            }
//        }
//        if (mineNumber >= 40) {
//            needContinue = NO;
//        }
//    }
    
   
    //检查周边雷的个数
    //如果本身是雷，不进行检查，否则，填写相应的雷数目
    for (int i = 0; i < kRow; i++) {
        NSMutableArray *rowArray = [self.dataSourceArray objectAtIndex:i];
        for (int j = 0; j < kLine; j++) {
            MineModel *model = [rowArray objectAtIndex:j];
            NSInteger mineNumber = 0;
            if (model.isMine == NO) {
                MineModel *leftUpContent = nil;
                MineModel *upContent = nil;
                MineModel *rightUpContent = nil;
                if (i > 0) {
                    NSMutableArray *upRowArray = [self.dataSourceArray objectAtIndex:i-1];
                    upContent = [upRowArray objectAtIndex:j];
                    if (upContent.isMine) {
                        mineNumber ++;
                    }
                    if (j > 0) {
                        leftUpContent = [upRowArray objectAtIndex:j-1];
                        if (leftUpContent.isMine) {
                            mineNumber++;
                        }
                    }
                    
                    if (j < (upRowArray.count-1)) {
                        rightUpContent = [upRowArray objectAtIndex:j+1];
                        if (rightUpContent.isMine) {
                            mineNumber ++;
                        }
                    }
                }
                
                MineModel *rightContent = nil;
                MineModel *leftContent = nil;
                if (j > 0) {
                    rightContent = [rowArray objectAtIndex:j-1];
                    if (rightContent.isMine) {
                        mineNumber ++;
                    }
                }
                
                if (j < (rowArray.count-1)) {
                    leftContent = [rowArray objectAtIndex:j+1];
                    if (leftContent.isMine) {
                        mineNumber ++;
                    }
                }
                
                MineModel *leftDownContent = nil;
                MineModel *downContent = nil;
                MineModel *rightDownContent = nil;
                if (i < (self.dataSourceArray.count -1)) {
                    NSMutableArray *downArray = [self.dataSourceArray objectAtIndex:i+1];
                    downContent = [downArray objectAtIndex:j];
                    if (downContent.isMine) {
                        mineNumber++;
                    }
                    if (j > 0) {
                        leftDownContent = [downArray objectAtIndex:j-1];
                        if (leftDownContent.isMine) {
                            mineNumber++;
                        }
                    }
                    if (j < (downArray.count -1)) {
                        rightDownContent = [downArray objectAtIndex:j+1];
                        if (rightDownContent.isMine) {
                            mineNumber ++;
                        }
                    }
                }
            }
            model.mineNumber = mineNumber;
        }
    }
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countUseTime) userInfo:nil repeats:YES];
    useTime = 0;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.collectionView reloadData];
//    });
    [self.collectionView reloadData];

//    [self.collectionView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[MineCell class]]) {
//            MineCell *cell = (MineCell*)obj;
//            cell.maskView.hidden = NO;
//        }
//    }];
}
- (void)countUseTime
{
    useTime++;
}
/*
 MineModel *model = [[self.dataSourceArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
 
 //    dispatch_queue_t queue = dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 //    dispatch_async(queue, ^{
 NSMutableArray *rowArray = [self.dataSourceArray objectAtIndex:indexPath.section];
 if (indexPath.row > 0) {
 MineModel *leftModel = [rowArray objectAtIndex:indexPath.row-1];
 if (leftModel.isMine==NO && leftModel.mineNumber==0) {
 NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
 if(leftModel.isSelected == NO){
 leftModel.isSelected = YES;
 [self findEnmptyCellIndexPath:tempIndexPath];
 }
 }else if (model.mineNumber == 0){
 leftModel.isSelected = YES;
 }
 }
 
 if (indexPath.row<(rowArray.count -1)) {
 MineModel *rightModel = [rowArray objectAtIndex:indexPath.row+1];
 if (rightModel.isMine==NO && rightModel.mineNumber == 0) {
 NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];
 if (rightModel.isSelected == NO) {
 rightModel.isSelected = YES;
 [self findEnmptyCellIndexPath:tempIndexPath];
 }
 }else if (model.mineNumber == 0){
 rightModel.isSelected = YES;
 }
 }
 
 if (indexPath.section > 0) {
 NSArray *upRowArray = [self.dataSourceArray objectAtIndex:indexPath.section-1];
 MineModel *upModel = [upRowArray objectAtIndex:indexPath.row];
 if (upModel.isMine==NO && upModel.mineNumber == 0) {
 NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section-1];
 if (upModel.isSelected == NO) {
 upModel.isSelected = YES;
 [self findEnmptyCellIndexPath:tempIndexPath];
 }
 }else if (model.mineNumber == 0){
 upModel.isSelected = YES;
 }
 }
 
 if (indexPath.section < (self.dataSourceArray.count-1)) {
 NSMutableArray *downArray = [self.dataSourceArray objectAtIndex:indexPath.section+1];
 MineModel *downModel = [downArray objectAtIndex:indexPath.row];
 if (downModel.isMine==NO && downModel.mineNumber == 0) {
 NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section+1];
 if (downModel.isSelected == NO) {
 downModel.isSelected = YES;
 [self findEnmptyCellIndexPath:tempIndexPath];
 }
 }else if (model.mineNumber == 0){
 downModel.isSelected = YES;
 }
 }
 //        dispatch_async(dispatch_get_main_queue(), ^{
 //           [self.collectionView reloadData];
 //        });
 //    });
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
