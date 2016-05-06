//
//  NewHomeServiceDuirationView.m
//  GuHouseKeeping
//
//  Created by David on 7/30/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "NewHomeServiceDurationView.h"
#import "NewHomeAreaTableViewCell.h"

typedef enum{
    isScroll,
    isSelect,
    isEnd
}ScrollViewStatus;

@interface NewHomeServiceDurationView()
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSArray *hourArr;
@property (nonatomic, strong) NSMutableDictionary *selectIndexs;
@end

@implementation NewHomeServiceDurationView
@synthesize delegate = _delegate;
@synthesize backGroundView = _backGroundView;
@synthesize hourArr = _hourArr;
@synthesize selectIndexs = _selectIndexs;

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_hourArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];//@"Cell";
    
    NewHomeAreaTableViewCell *cell = (NewHomeAreaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"NewHomeAreaTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    [cell.titleLabel setText:_hourArr[indexPath.row]];
    
    [self customAction:tableView withCell:cell AtIndexPath:indexPath scrollStatus:isScroll];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewHomeAreaTableViewCell *cell = (NewHomeAreaTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self customAction:tableView withCell:cell AtIndexPath:indexPath scrollStatus:isSelect];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self customAction:scrollView withCell:nil AtIndexPath:nil scrollStatus:isEnd];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self customAction:scrollView withCell:nil AtIndexPath:nil scrollStatus:isEnd];
}



- (void)custom:(UITableView *)tableView  withTableName:(NSString *)tableName withCell:(NewHomeAreaTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath scrollStatus:(ScrollViewStatus)status{
    if (status == isScroll) {
        if ([[_selectIndexs allKeys] containsObject:tableName]) {
            if (indexPath.row == [_selectIndexs[tableName] integerValue]) {
                [cell.titleLabel setTextColor:GREENCOLO];
            }else{
                [cell.titleLabel setTextColor:[UIColor blackColor]];
            }
        }
    }else if (status == isSelect){
        if ([[_selectIndexs allKeys] containsObject:tableName]) {
            NewHomeAreaTableViewCell *tmpCell = (NewHomeAreaTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_selectIndexs[tableName] integerValue] inSection:0]];
            [tmpCell.titleLabel setTextColor:[UIColor blackColor]];
        }
        [cell.titleLabel setTextColor:GREENCOLO];
        [_selectIndexs setObject:[NSNumber numberWithInt:indexPath.row] forKey:tableName];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    }else{
        CGPoint point  = CGPointMake(CGRectGetWidth(tableView.frame) / 2.0, tableView.contentOffset.y + CGRectGetHeight(tableView.frame) / 2.0);
        NSIndexPath *finalIndexPath = [tableView indexPathForRowAtPoint:point];
        if ([[_selectIndexs allKeys] containsObject:tableName]) {
            NewHomeAreaTableViewCell *tmpCell = (NewHomeAreaTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_selectIndexs[tableName] integerValue] inSection:0]];
            [tmpCell.titleLabel setTextColor:[UIColor blackColor]];
        }
        [_selectIndexs setObject:[NSNumber numberWithInt:finalIndexPath.row] forKey:tableName];
        
        
        DLog(@"%@", _selectIndexs);
        
        NewHomeAreaTableViewCell *FinalCell = (NewHomeAreaTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[NSNumber numberWithInt:finalIndexPath.row] integerValue] inSection:0]];
        [FinalCell.titleLabel setTextColor:GREENCOLO];
        
        [tableView scrollToRowAtIndexPath:finalIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
    
}

- (void)customAction:(UIScrollView *)scrollView withCell:(NewHomeAreaTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath scrollStatus:(ScrollViewStatus)status{
    [self custom:_firstTableView withTableName:@"_firstTableView" withCell:cell AtIndexPath:indexPath scrollStatus:status];
}


- (void)reloadInputData:(NSDictionary *)dataDic{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:self.bounds];
        
        CALayer *flowerlayer = [[CALayer alloc] init];
        [flowerlayer setFrame:_backGroundView.bounds];
        [flowerlayer setContents:(id)[[UIImage imageNamed:@"new_home_servie_duration.png"] CGImage]];
        [_backGroundView.layer addSublayer:flowerlayer];
        [_backGroundView setUserInteractionEnabled:NO];
        [self addSubview:_backGroundView];
    }
    
    
    [_firstTableView setContentInset:UIEdgeInsetsMake(48, 0, 48, 0)];
    
    if (dataDic) {
        _selectIndexs = [NSMutableDictionary dictionaryWithDictionary:dataDic];
    }
    
    if (!_selectIndexs) {
        _selectIndexs = [[NSMutableDictionary alloc] init];
    }
    _hourArr = @[ @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    [_firstTableView reloadData];
    if ([[_selectIndexs allKeys] containsObject:@"_firstTableView"]) {
        int selectIndex = [ _hourArr indexOfObject:_selectIndexs[@"_firstTableView"]];
        if (selectIndex >= [_hourArr count]) {
            selectIndex = 0;
            [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_firstTableView"];
        }else{
            [_selectIndexs setObject:[NSNumber numberWithInt:selectIndex] forKey:@"_firstTableView"];
        }
        [_firstTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}


- (IBAction)buttonClick:(id)sender {
    if ([_firstTableView isDecelerating] && [_firstTableView isDragging]) {
        return;
    }
    if ([_delegate respondsToSelector:@selector(newHomeServiceDurationViewSelect:)]) {
        self.userInteractionEnabled = NO;
        
        [self customAction:_firstTableView withCell:nil AtIndexPath:nil scrollStatus:isEnd];
        
        NSString *string = [NSString stringWithFormat:@"%@",
                            _hourArr[[_selectIndexs[@"_firstTableView"] integerValue]]
                            ];
        DLog(@"%@", string);
        [_delegate newHomeServiceDurationViewSelect:string];
    }
}
@end
