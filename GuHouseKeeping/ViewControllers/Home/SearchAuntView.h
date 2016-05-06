//
//  SearchAuntView.h
//  GuHouseKeeping
//
//  Created by David on 8/14/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SearchAuntViewDelegate <NSObject>

- (void)SearchAuntViewSelectAunt:(AuntInfoModel *)info;

@end

@interface SearchAuntView : UIView

@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) id<SearchAuntViewDelegate>delegate;

- (void)initCollectionView;
@end
