//
//  NewHomeServiceTimeView.m
//  GuHouseKeeping
//
//  Created by David on 7/28/14.
//  Copyright (c) 2014 David. All rights reserved.
//

#import "NewHomeServiceTimeView.h"
#import "NewHomeAreaTableViewCell.h"

typedef enum{
    isScroll,
    isSelect,
    isEnd
}ScrollViewStatus;

@interface NewHomeServiceTimeView()
@property (nonatomic, strong) UIView *backGroundView;
@property (nonatomic, strong) NSArray *yearArr;
@property (nonatomic, strong) NSArray *monthArr;
@property (nonatomic, strong) NSArray *dayArr;
@property (nonatomic, strong) NSArray *hourArr;
@property (nonatomic, strong) NSArray *minuteArr;
@property (nonatomic, strong) NSMutableDictionary *selectIndexs;
@end

@implementation NewHomeServiceTimeView
@synthesize backGroundView = _backGroundView;
@synthesize yearArr = _yearArr;

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
    if (tableView == _firstTableView) {
        return [_yearArr count];
    }else if (tableView == _secondTableView){
        return [_monthArr count];
    }else if(tableView == _thirdTableView){
        return [_dayArr count];}
    else if(tableView== _forthTableView )
    {
        return [_hourArr count];
    }
    else
    {
        return [_minuteArr count];
    }
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
    
    
    if (tableView == _firstTableView) {
        [cell.titleLabel setText:_yearArr[indexPath.row]];
    }else if (tableView == _secondTableView){
        [cell.titleLabel setText:_monthArr[indexPath.row]];
    }else if (tableView == _thirdTableView) {
        [cell.titleLabel setText:_dayArr[indexPath.row]];
    }
    else if(tableView==_forthTableView){
        [cell.titleLabel setText:_hourArr[indexPath.row]];
        
    }
    else{
        [cell.titleLabel setText:_minuteArr[indexPath.row]];
    }

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






- (void)checkTableView:(UITableView *)tableView{
    if (tableView == _firstTableView || tableView == _secondTableView) {
        
        DLog(@"%d", [_yearArr[[_selectIndexs[@"_firstTableView"] integerValue]] integerValue]);
        DLog(@"%d", [_monthArr[[_selectIndexs[@"_secondTableView"] integerValue]] integerValue]);
        //DLog(@"%d", [_hourArr[[_selectIndexs[@"_thirdTableView"] integerValue]] integerValue]);
        
        
        int days = [self dayInSelectYear:[_selectIndexs[@"_firstTableView"] integerValue]
                                andMonth:[_selectIndexs[@"_secondTableView"] integerValue]];
        
        
        if ([_dayArr count] != days) {
            NSMutableArray *tmpDays = [[NSMutableArray alloc] init];
            for (int i = 1; i <= days; i++) {
                [tmpDays addObject:[NSString stringWithFormat:@"%d", i]];
            }
            _dayArr = [NSArray arrayWithArray:tmpDays];
            
            [_thirdTableView reloadData];
            
            if ([_selectIndexs[@"_thirdTableView"] intValue] < [_dayArr count]) {

            }else{
                [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_thirdTableView"];
            }
            [_thirdTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_selectIndexs[@"_thirdTableView"] integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            
        }
        
   
        
    }
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

        [self checkTableView:tableView];
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
        [self checkTableView:tableView];
    }
    
}









- (void)customAction:(UIScrollView *)scrollView withCell:(NewHomeAreaTableViewCell *)cell AtIndexPath:(NSIndexPath *)indexPath scrollStatus:(ScrollViewStatus)status{
    if (scrollView == _firstTableView) {
        [self custom:_firstTableView withTableName:@"_firstTableView" withCell:cell AtIndexPath:indexPath scrollStatus:status];
    }else if (scrollView == _secondTableView) {
        [self custom:_secondTableView withTableName:@"_secondTableView" withCell:cell AtIndexPath:indexPath scrollStatus:status];
    }else if (scrollView == _thirdTableView) {
        [self custom:_thirdTableView withTableName:@"_thirdTableView" withCell:cell AtIndexPath:indexPath scrollStatus:status];
    }
    else if (scrollView == _forthTableView) {
        [self custom:_forthTableView withTableName:@"_forthTableView" withCell:cell AtIndexPath:indexPath scrollStatus:status];
    }
    else if (scrollView == _fifthTableView) {
        [self custom:_fifthTableView withTableName:@"_fifthTableView" withCell:cell AtIndexPath:indexPath scrollStatus:status];
    }


}







- (IBAction)buttonClick:(id)sender {
    if ([_firstTableView isDecelerating] && [_firstTableView isDragging]) {
        return;
    }
    
    if ([_secondTableView isDecelerating] && [_secondTableView isDragging]) {
        return;
    }
    
    if ([_thirdTableView isDecelerating] && [_thirdTableView isDragging]) {
        return;
    }
    
    if ([_forthTableView isDecelerating] && [_forthTableView isDragging]) {
        return;
    }

    if ([_fifthTableView isDecelerating] && [_fifthTableView isDragging]) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(newHomeServiceTimeViewSelect:)]) {
        self.userInteractionEnabled = NO;
        
        [self customAction:_firstTableView withCell:nil AtIndexPath:nil scrollStatus:isEnd];
        [self customAction:_secondTableView withCell:nil AtIndexPath:nil scrollStatus:isEnd];
        [self customAction:_thirdTableView withCell:nil AtIndexPath:nil scrollStatus:isEnd];
        [self customAction:_forthTableView withCell:nil AtIndexPath:nil scrollStatus:isEnd];
        [self customAction:_fifthTableView withCell:nil AtIndexPath:nil scrollStatus:isEnd];
//
        
        NSString *string = [NSString stringWithFormat:@"%@年%@月%@日%@时%@分",
                            _yearArr[[_selectIndexs[@"_firstTableView"] integerValue]],
                            _monthArr[[_selectIndexs[@"_secondTableView"] integerValue]],
                            _dayArr[[_selectIndexs[@"_thirdTableView"] integerValue]],
                            _hourArr[[_selectIndexs[@"_forthTableView"] integerValue]],
                            _minuteArr[[_selectIndexs[@"_fifthTableView"] integerValue]]
                            ];
        
        DLog(@"%@", string);
        [_delegate newHomeServiceTimeViewSelect:string];
    }
}

- (void)reloadInputData:(NSDictionary *)dataDic{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:self.bounds];
        
        CALayer *flowerlayer = [[CALayer alloc] init];
        [flowerlayer setFrame:_backGroundView.bounds];
        [flowerlayer setContents:(id)[[UIImage imageNamed:@"new_home_servie_time.png"] CGImage]];
        [_backGroundView.layer addSublayer:flowerlayer];
        [_backGroundView setUserInteractionEnabled:NO];
        [self addSubview:_backGroundView];
    }
    
    [_firstTableView setContentInset:UIEdgeInsetsMake(48, 0, 48, 0)];
    [_secondTableView setContentInset:UIEdgeInsetsMake(48, 0, 48, 0)];
    [_thirdTableView setContentInset:UIEdgeInsetsMake(48, 0, 48, 0)];
    [_forthTableView setContentInset:UIEdgeInsetsMake(48, 0, 48, 0)];
    [_fifthTableView setContentInset:UIEdgeInsetsMake(48, 0, 48, 0)];

    
    NSDate *today = [NSDate date];

    NSCalendar *cal = [NSCalendar currentCalendar];
    
    
    
    
    NSDateComponents *comps =[cal components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
                       fromDate:today];


    NSString *weekDayString = nil;
    switch ([comps weekday]) {
        case 1:{
            weekDayString = @"周日";
        }
            break;
        case 2:{
            weekDayString = @"周一";
        }
            break;
        case 3:{
            weekDayString = @"周二";
        }
            break;
        case 4:{
            weekDayString = @"周三";
        }
            break;
        case 5:{
            weekDayString = @"周四";
        }
            break;
        case 6:{
            weekDayString = @"周五";
        }
            break;
        case 7:{
            weekDayString = @"周六";
        }
            break;
        default:
            break;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    [_titleLabel setText:[NSString stringWithFormat:@"%@ %@ ", [formatter stringFromDate:today], weekDayString]];
    
    
    [formatter setDateFormat:@"yyyy"];
    
    
    
    
    
    
    
    NSMutableArray *tmpYear = [[NSMutableArray alloc] init];
    
    int startYear = [[formatter stringFromDate:today] integerValue];
    
    for (int i = 0; i < 11; i ++) {
        [tmpYear addObject:[NSString stringWithFormat:@"%d", startYear + i]];
    }
    _yearArr = [NSArray arrayWithArray:tmpYear];
    
    if (!_selectIndexs) {
        _selectIndexs = [[NSMutableDictionary alloc] init];
    }

    if ([[dataDic allKeys] containsObject:@"_firstTableView"]) {
        if ([_yearArr containsObject:dataDic[@"_firstTableView"]]) {
            [_selectIndexs setObject:[NSNumber numberWithInt:[_yearArr indexOfObject:dataDic[@"_firstTableView"]]] forKey:@"_firstTableView"];
        }else{
            [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_firstTableView"];
        }
    }else{
        [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_firstTableView"];
    }
    
    
    
    
    
    NSMutableArray *tmpMonthArr = [[NSMutableArray alloc] init];
    for (int i = 1; i < 13; i ++) {
        [tmpMonthArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    _monthArr = [NSArray arrayWithArray:tmpMonthArr];
   
    if ([[dataDic allKeys] containsObject:@"_secondTableView"]) {
        if ([_monthArr containsObject:[NSString stringWithFormat:@"%d", [dataDic[@"_secondTableView"] integerValue]]]) {
            [_selectIndexs setObject:[NSNumber numberWithInt:[_monthArr indexOfObject:[NSString stringWithFormat:@"%d", [dataDic[@"_secondTableView"] integerValue]]]] forKey:@"_secondTableView"];
        }else{
            [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_secondTableView"];
        }
    }else{
        [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_secondTableView"];
    }
    
    
    
    
    
    
    int days = [self dayInSelectYear:[_selectIndexs[@"_firstTableView"] integerValue]
                            andMonth:[_selectIndexs[@"_secondTableView"] integerValue]];
   
    NSMutableArray *tmpDays = [[NSMutableArray alloc] init];
    for (int i = 1; i <= days; i++) {
        [tmpDays addObject:[NSString stringWithFormat:@"%d", i]];
    }
    _dayArr = [NSArray arrayWithArray:tmpDays];
    
    if ([[dataDic allKeys] containsObject:@"_thirdTableView"]) {
        if ([_dayArr containsObject:dataDic[@"_thirdTableView"]]) {
            [_selectIndexs setObject:[NSNumber numberWithInt:[_dayArr indexOfObject:dataDic[@"_thirdTableView"]]] forKey:@"_thirdTableView"];
        }else{
            [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_thirdTableView"];
        }
    }else{
        [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_thirdTableView"];
    }
    
    
    

    
    
    NSMutableArray *tmpHourArr = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 24; i++) {
        [tmpHourArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    _hourArr = [NSArray arrayWithArray:tmpHourArr];
    
    if ([[dataDic allKeys] containsObject:@"_forthTableView"]) {
        if ([_hourArr containsObject:[NSString stringWithFormat:@"%d", [dataDic[@"_forthTableView"] integerValue]]]) {
            [_selectIndexs setObject:[NSNumber numberWithInt:[_hourArr indexOfObject:[NSString stringWithFormat:@"%d", [dataDic[@"_hourTableView"] integerValue]]]] forKey:@"_hourTableView"];
        }else{
            [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_hourTableView"];
        }
    }else{
        [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_hourTableView"];
    }
    
    
    
    
    NSMutableArray *tmpMinuteArr= [[NSMutableArray alloc] init];
    for (int i = 1; i <= 60; i++) {
        [tmpMinuteArr addObject:[NSString stringWithFormat:@"%d", i]];
    }
    _minuteArr = [NSArray arrayWithArray:tmpMinuteArr];
    if ([[dataDic allKeys] containsObject:@"_fifthTableView"]) {
        if ([_minuteArr containsObject:dataDic[@"_fifthTableView"]]) {
            [_selectIndexs setObject:[NSNumber numberWithInt:[_minuteArr indexOfObject:dataDic[@"_fifthTableView"]]] forKey:@"_fifthTableView"];
        }else{
            [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_fifthTableView"];
        }
    }else{
        [_selectIndexs setObject:[NSNumber numberWithInt:0] forKey:@"_fifthTableView"];
    }
    
    
    DLog(@"%@", _selectIndexs);
    
    [_firstTableView reloadData];
    [_secondTableView reloadData];
    [_thirdTableView reloadData];
    [_forthTableView reloadData];
    [_fifthTableView reloadData];
    
    [_firstTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_selectIndexs[@"_firstTableView"] integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [_secondTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_selectIndexs[@"_secondTableView"] integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];

    [_thirdTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_selectIndexs[@"_thirdTableView"] integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    [_forthTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_selectIndexs[@"_forthTableView"] integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];

    [_fifthTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_selectIndexs[@"_fifthTableView"] integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];


}


- (int)dayInSelectYear:(int)year andMonth:(int)month{
    if (month == 0 || month == 2 || month == 4 || month == 6 || month == 7 || month == 9 || month == 11){
        return 31;
    }else if (month == 1){
        if(((year % 4 == 0)&&(year % 100 !=0))||(year % 400 == 0)){
            return 29;
        }else{
            return 28;
        }
    }else{
        return 30;
    }
}


@end
