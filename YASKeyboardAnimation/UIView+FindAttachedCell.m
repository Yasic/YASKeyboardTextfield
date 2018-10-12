//
//  UIView+FindAttachedCell.m
//  YASKeyboardAnimation
//
//  Created by yasic on 2018/10/12.
//  Copyright © 2018年 yasic. All rights reserved.
//

#import "UIView+FindAttachedCell.h"

@implementation UIView (FindAttachedCell)

- (UITableViewCell*)findAttachedCell
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell*)self;
    }
    if (self.superview) {
        UITableViewCell *tableViewCell = [self.superview findAttachedCell];
        if (tableViewCell != nil) {
            return tableViewCell;
        }
        return [self.superview findAttachedCell];
    }
    return nil;
}

@end
