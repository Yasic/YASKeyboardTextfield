//
//  YASInputCell.m
//  YASKeyboardAnimation
//
//  Created by yasic on 2018/10/11.
//  Copyright © 2018年 yasic. All rights reserved.
//

#import "YASInputCell.h"

@interface YASInputCell()

@end

@implementation YASInputCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self addViews];
    }
    return self;
}

- (void)addViews
{
    [self addSubview:self.textInput];
}

- (UITextField *)textInput
{
    if (!_textInput) {
        _textInput = [[UITextField alloc] initWithFrame:CGRectMake(0, 44, 100, 44)];
    }
    return _textInput;
}

@end
