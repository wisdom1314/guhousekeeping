//
//  SearchChoosePopView.m
//  GuHouseKeeping
//
//  Created by luyun on 14-7-26.
//  Copyright (c) 2014年 David. All rights reserved.
//

#import "SearchChoosePopView.h"
#import "SearchChoosePopTableViewCell.h"

@implementation SearchChoosePopView

- (id)initWithFrame:(CGRect)frame withTableViewFram:(CGRect)tableViewFrame tableViewArr:(NSArray *)tableViewArr viewComeForm:(NSString *)comeForm withIndex:(int)selectInt{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
//        UIView *bgView = [[UIView alloc] initWithFrame:self.frame];
//        [bgView setBackgroundColor:[UIColor blackColor]];
//        [bgView setAlpha:0.5f];
//        [self addSubview:bgView];
        
        UIButton *bgBtn = [[UIButton alloc] initWithFrame:self.frame];
        [bgBtn setBackgroundColor:[UIColor blackColor]];
        [bgBtn addTarget:self action:@selector(hidenView:) forControlEvents:UIControlEventTouchUpInside];
        [bgBtn setAlpha:0.3f];
        [self addSubview:bgBtn];
        _selectInt = selectInt;
        
        _tableViewArr = [NSArray arrayWithArray:tableViewArr];
        
        _myTableView = [[UITableView alloc] initWithFrame:tableViewFrame];
        [_myTableView setDelegate:(id<UITableViewDelegate>)self];
        [_myTableView setDataSource:(id<UITableViewDataSource>)self];
        [_myTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_myTableView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_myTableView];
        
        [self.myTableView reloadData];
        
        
        [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectInt inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        _comeFormStr = comeForm;
        
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_tableViewArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    SearchChoosePopTableViewCell *cell = (SearchChoosePopTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SearchChoosePopTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    
    if (_selectInt == indexPath.row) {
        cell.selectIMg.image = [UIImage imageNamed:@"search_hover_dot.png"];
        cell.titleLbl.textColor = COLORRGBA(122, 204, 0, 1.0);
    }else{
        cell.selectIMg.image = [UIImage imageNamed:@"search_normal_dot.png"];
        cell.titleLbl.textColor = [UIColor blackColor];
    }
    cell.titleLbl.text = [_tableViewArr objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (_selectInt == -1) {
//        
//        _selectInt = indexPath.row;
//        
//        
//    }else{
//        if (_selectInt == indexPath.row) {
//            
//            _selectInt = -1;
//            
//        }else{
//            
//            _selectInt = indexPath.row;
//            
//        }
//    }
    
    _selectInt = indexPath.row;
    
    if ([_searchDelegate respondsToSelector:@selector(setChooseWithkey:viewComeForm:)]) {
        [_searchDelegate setChooseWithkey:[_tableViewArr objectAtIndex:indexPath.row] viewComeForm:_comeFormStr];
    }
    
    [self.myTableView reloadData];
    [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectInt inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)hidenView:(UIButton *)sender{
    [UIView animateWithDuration:.3f animations:^{
        [self setAlpha:0.f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
