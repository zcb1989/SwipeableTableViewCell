//
//  SwipeableTableViewCell.m
//  SwipeableTableViewCell
//
//  Created by ZCB-MAC on 15/10/29.
//  Copyright © 2015年 ZCB-MAC. All rights reserved.
//

#import "SwipeableTableViewCell.h"

NSString *const kSwipeableTableViewCellCloseEvent = @"SwipeableTableViewCellClose";

CGFloat const kSwipeableTableViewCellMaxCloseMilliseconds = 300;
CGFloat const kSwipeableTableViewCellOpenVelocityThreshold = 0.6;

@interface SwipeableTableViewCell ()

@property (nonatomic,strong) NSArray *buttonViews;

@end

@implementation SwipeableTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self setUp];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUp];
    }
    return self;
}
#pragma mark Pbulic class methods
+(void)closeAllCells{
    
}
+(void)closeAllCellsExcept:(SwipeableTableViewCell *)cell{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwipeableTableViewCellCloseEvent object:cell];
}
#pragma mark Public properties
- (BOOL)closed{
    return CGPointEqualToPoint(self.scrollView.contentOffset, CGPointZero);
}
- (CGFloat)leftInset{
    UIView *view = self.buttonViews[SwipeableTableViewCellSideLeft];
    return view.bounds.size.width;
}
- (CGFloat)rightInset{
    UIView *view = self.buttonViews[SwipeableTableViewCellSideRight];
    return view.bounds.size.width;
}
- (void)handleCloseEvent:(NSNotification *)notification{
    
    if (notification.object == self) {
        return;
    }
    [self close];
}

- (void)setUp{
    
    //1
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    scrollView.contentSize = self.contentView.bounds.size;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:scrollView];
    self.scrollView = scrollView;
    
    //4
    self.buttonViews = @[[self createButtonsView],[self createButtonsView]];
    //2
    UIView *contentView = [[UIView alloc] initWithFrame:scrollView.bounds];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    contentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:contentView];
    self.scrollViewContentView = contentView;
    
    //3
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(contentView.bounds, 10, 0)];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.scrollViewContentView addSubview:label];
    self.scrollViewLabel = label;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCloseEvent:) name:kSwipeableTableViewCellCloseEvent object:nil];
    
}

- (UIView *)createButtonsView{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.contentView.bounds.size.height)];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.scrollView addSubview:view];
    return view;
}
#pragma mark Public methods

- (void)close{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}
- (UIButton *)createButtonWithWidth:(CGFloat)width onSide:(SwipeableTableViewCellSide)side{
    UIView *container = self.buttonViews[side];
    CGSize size = container.bounds.size;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    button.frame = CGRectMake(size.width, 0, width, size.height);
    
    CGFloat x;
    switch (side) {
        case SwipeableTableViewCellSideLeft:
        {
            x = - (size.width + width);
        }
            break;
        case SwipeableTableViewCellSideRight:
        {
            x = self.contentView.bounds.size.width;
        }
            break;
            
        default:
            break;
    }
    container.frame = CGRectMake(x, 0, size.width + width, size.height);
    [container addSubview:button];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, self.leftInset, 0, self.rightInset);
    
    return button;
}

- (void)openSide:(SwipeableTableViewCellSide)side{
    [self openSide:side animated:YES];
}

- (void)openSide:(SwipeableTableViewCellSide)side animated:(BOOL)animate{
    [[self class] closeAllCellsExcept:self];
    switch (side) {
        case SwipeableTableViewCellSideLeft:
        {
            [self.scrollView setContentOffset:CGPointMake(-self.leftInset, 0) animated:animate];
        }
            break;
        case SwipeableTableViewCellSideRight:
        {
            [self.scrollView setContentOffset:CGPointMake(self.rightInset, 0) animated:animate];
        }
            break;
            
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ((self.leftInset == 0 && scrollView.contentOffset.x <0) || (self.rightInset == 0 && scrollView.contentOffset.x >0)) {
        
        scrollView.contentOffset = CGPointZero;
        
        UIView *leftView = self.buttonViews[SwipeableTableViewCellSideLeft];
        UIView *rightView = self.buttonViews[SwipeableTableViewCellSideRight];
        
        if (scrollView.contentOffset.x <0) {
            leftView.frame = CGRectMake(scrollView.contentOffset.x, 0, self.leftInset, leftView.frame.size.height);
            leftView.hidden = NO;
            rightView.hidden = YES;
        }else if (scrollView.contentOffset.x >0){
            rightView.frame = CGRectMake(self.contentView.bounds.size.width - self.rightInset + scrollView.contentOffset.x, 0, self.rightInset, rightView.frame.size.height);
            rightView.hidden = NO;
            leftView.hidden = YES;
        }else{
            leftView.hidden = YES;
            rightView.hidden = YES;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self class]closeAllCellsExcept:self];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat x = scrollView.contentOffset.x,left = self.leftInset,right = self.rightInset;
    if (left>0 && (x<-left ||(x<0 && velocity.x < -kSwipeableTableViewCellOpenVelocityThreshold))) {
        targetContentOffset->x = - left;
    }else if (right>0 && (x >right || (x>0 && velocity.x > kSwipeableTableViewCellOpenVelocityThreshold)){
        targetContentOffset->x = right;
    }
}

@end
