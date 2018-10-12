//
//  UIView+FindFirstResponder.m
//  YASKeyboardAnimation
//
//  Created by yasic on 2018/10/12.
//  Copyright © 2018年 yasic. All rights reserved.
//

#import "UIView+FindFirstResponder.h"

@implementation UIView (FindFirstResponder)

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResponder];
        if (firstResponder != nil) {
            return firstResponder;
        }
    }
    return nil;
}

@end
