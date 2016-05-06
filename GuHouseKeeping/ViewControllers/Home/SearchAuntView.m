//
//  SearchAuntView.m
//  GuHouseKeeping
//
//  Created by David on 8/14/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "SearchAuntView.h"
#import "SearchAuntCell.h"
#import "AuntInfoModel.h"
#import "UIImageView+AFNetworking.h"

@interface SearchAuntView()
@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, strong) NSMutableArray *array;
@end


@implementation SearchAuntView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (void)initCollectionView{
    [HHM postCollectAuntServiceFindCollectAuntList:@{@"userId":HDM.memberId,
                                                     @"page":@"{\"pageNo\": 1, \"pageSize\": 10 }"
                                                     } success:^(NSArray *info) {
                                                         DLog(@"info:%@", info);
                                                         if (info) {
                                                             _array = [NSMutableArray arrayWithArray:info];
                                                             [_array addObject:@""];
                                                             UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                                                             layout.itemSize = CGSizeMake(100, 100);
                                                             //    layout.sectionInset = UIEdgeInsetsMake(100, 0, 0, 0);
                                                             layout.minimumInteritemSpacing = 0.0;
                                                             layout.minimumLineSpacing = 0.0;
                                                             
                                                             [_myCollectionView setCollectionViewLayout:layout];
                                                             [_myCollectionView setDelegate:(id<UICollectionViewDelegate>)self];
                                                             [_myCollectionView setDataSource:(id<UICollectionViewDataSource>)self];
                                                             [_myCollectionView registerClass:[SearchAuntCell class] forCellWithReuseIdentifier:@"SearchAuntCell"];
                                                             
                                                             
                                                         }
                                                         
                                                     } failure:^(NSError *error) {
                                                         [HDM errorPopMsg:error];
                                                     }];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [self addGestureRecognizer:longPress];

}

- (void)longPressGestureRecognized:(UIGestureRecognizer *)recognizer{
    if (!_isDel) {
        _isDel = YES;
        
        [_myCollectionView reloadData];
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_array count];
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchAuntCell *cell = (SearchAuntCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SearchAuntCell" forIndexPath:indexPath];
    

    if (_isDel) {
        [cell.delButton setHidden:NO];
        [cell.delButton addTarget:self action:@selector(delButton: event:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.delButton setHidden:YES];
    }
    
    if (indexPath.row == [_array count] - 1) {
        [cell.delButton setHidden:YES];
        [cell.avartIcon setImage:[UIImage imageNamed:@"main_add.png"]];
        [cell.nameLabel setText:@"添加"];
    }else{
        AuntInfoModel *info = _array[indexPath.row];
        
        if (info.imageUrl) {
            [cell.avartIcon setImageWithURL:[NSURL URLWithString:info.imageUrl] placeholderImage:[UIImage imageNamed:@"worker_icon.png"]];
        }else{
            [cell.avartIcon setImage:[UIImage imageNamed:@"worker_icon.png"]];
        }
        
        [cell.nameLabel setText:info.userName];
    }
    
    
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(100 , 100);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //    return UIEdgeInsetsMake(3.5, 3.5, 0, 3.5);
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"%@", indexPath);
    
//    [_myCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
    
    if ([_delegate respondsToSelector:@selector(SearchAuntViewSelectAunt:)]) {
        if (indexPath.row == [_array count] - 1) {
            [_delegate SearchAuntViewSelectAunt:nil];
        }else{
            AuntInfoModel *info = _array[indexPath.row];
            [_delegate SearchAuntViewSelectAunt:info];
        }
    }
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)delButton:(id)sender event:(id)event{
    NSSet *touches = [event allTouches];
	UITouch *touch = [touches anyObject];
	CGPoint currentTouchPosition = [touch locationInView:_myCollectionView];
    NSIndexPath *indexPath =[_myCollectionView indexPathForItemAtPoint:currentTouchPosition];
    DLog(@"%@", indexPath);
    
    AuntInfoModel *info = _array[indexPath.row];
    
    
    [HHM postCollectAuntServiceDeleteCollectAunt:@{@"collectId": info.collectId} success:^(NSString *info) {
        if ([info isEqualToString:@"SUCCESS"]) {
            [_array removeObjectAtIndex:indexPath.row];
            [ _myCollectionView deleteItemsAtIndexPaths:@[indexPath]];
        }else{
            [HDM popHlintMsg:@"删除失败！"]; 
        }
    } failure:^(NSError *error) {
        [HDM errorPopMsg:error];
    }];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self customAction:scrollView];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self customAction:scrollView];
}


- (void)customAction:(UIScrollView *)scrollView{
//   __block int row = 10000000;
//        [_myCollectionView.indexPathsForVisibleItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//            DLog(@"%@", obj);
//            NSIndexPath *indexPath = (NSIndexPath *)obj;
//            if (indexPath.row < row) {
//                row = indexPath.row;
//            }
//        }];
//    
//    if (![_myCollectionView isDragging] && ![_myCollectionView isDecelerating]) {
//        [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:row inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
//    }
}
@end
