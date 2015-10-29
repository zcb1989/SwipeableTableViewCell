//
//  SwipeableTableViewCell.h
//  SwipeableTableViewCell
//
//  Created by ZCB-MAC on 15/10/29.
//  Copyright © 2015年 ZCB-MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SwipeableTableViewCellSide) {
    SwipeableTableViewCellSideLeft,
    SwipeableTableViewCellSideRight,
};

@interface SwipeableTableViewCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic, readonly) BOOL closed;
@property (nonatomic, readonly) CGFloat leftInset;
@property (nonatomic, readonly) CGFloat rightInset;

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *scrollViewContentView;
@property (nonatomic, weak) UILabel *scrollViewLabel;


+ (void)closeAllCells;
+ (void)closeAllCellsExcept:(SwipeableTableViewCell *)cell;
- (void)close;
- (UIButton *)createButtonWithWidth:(CGFloat)width onSide:(SwipeableTableViewCellSide)side;
- (void)openSide:(SwipeableTableViewCellSide)side;
- (void)openSide:(SwipeableTableViewCellSide)side animated:(BOOL)animate;

@end
