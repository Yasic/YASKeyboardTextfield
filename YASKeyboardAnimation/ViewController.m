//
//  ViewController.m
//  YASKeyboardAnimation
//
//  Created by yasic on 2018/10/11.
//  Copyright © 2018年 yasic. All rights reserved.
//

#import "ViewController.h"
#import "YASInputCell.h"
#import "UIView+FindFirstResponder.h"
#import "UIView+FindAttachedCell.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *hiddenKeyboardButton;

@property (nonatomic, strong) UITableView *inputTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addViews];
    
    // 添加键盘弹出事件监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    // 添加键盘隐藏事件监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    // 取出当前第一响应者
    UIView *firstResponderView = [self.inputTableView findFirstResponder];
    // 取出第一响应者所在的 cell
    UITableViewCell *cell = [firstResponderView findAttachedCell];
    if (!cell) {
        return;
    }
    
    // 取出 userInfo，其中包含一些与键盘相关的信息，如
    // UIKeyboardFrameEndUserInfoKey 键盘在屏幕坐标系中最终展示的矩形 frame 尺寸
    // UIKeyboardAnimationDurationUserInfoKey 键盘弹出动画时长
    // UIKeyboardAnimationCurveUserInfoKey 键盘弹出动画曲线
    NSDictionary *keyboardInfo = [notification userInfo];
    // 将键盘 frame 转换到 tableView 上
    CGRect keyboardFrame = [self.inputTableView.window convertRect:[keyboardInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.inputTableView.superview];
    // 计算出 tableview 底部被键盘遮挡的区域
    CGFloat newBottomInset = self.inputTableView.frame.origin.y + self.inputTableView.frame.size.height - keyboardFrame.origin.y;
    UIEdgeInsets tableContentInset = self.inputTableView.contentInset;
    NSNumber *currentBottomTableContentInset = @(tableContentInset.bottom);
    if (newBottomInset > [currentBottomTableContentInset floatValue]) { // 的确遮挡了 tableview
        tableContentInset.bottom = newBottomInset;
        // 启动动画
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:[keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
        [UIView setAnimationCurve:[keyboardInfo[UIKeyboardAnimationCurveUserInfoKey] intValue]];
        // 改变 tableView 的 contentInset
        self.inputTableView.contentInset = tableContentInset;
        // 滚动到第一响应者所在的 cell，UITableViewScrollPositionNone 保证以最小的滚动完全展示 cell
        NSIndexPath *selectedRow = [self.inputTableView indexPathForCell:cell];
        [self.inputTableView scrollToRowAtIndexPath:selectedRow atScrollPosition:UITableViewScrollPositionNone animated:NO];
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.inputTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)changeTableViewInset
{
    UIEdgeInsets tableContentInset = self.inputTableView.contentInset;
    if (self.inputTableView.contentInset.bottom == 100) {
        tableContentInset.bottom = 0;
    } else {
        tableContentInset.bottom = 100;
    }
    self.inputTableView.contentInset = tableContentInset;
}

- (void)hiddenKeyboard
{
    [self resignFirstResponder];
}

#pragma mark tableView代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YASInputCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell.textInput resignFirstResponder];
    [self.view endEditing:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YASInputCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([YASInputCell class])];
    [cell.textInput setText:[NSString stringWithFormat:@"index %ld", indexPath.row]];
    return cell;
}

- (void)addViews
{
    [self.view addSubview:self.inputTableView];
    [self.view addSubview:self.hiddenKeyboardButton];
}

- (UITableView *)inputTableView
{
    if (!_inputTableView) {
        _inputTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+32, self.view.frame.size.width, self.view.frame.size.height - 44 - 32) style:UITableViewStylePlain];
        _inputTableView.clipsToBounds = YES;
        _inputTableView.layer.masksToBounds = YES;
        _inputTableView.estimatedRowHeight = 0;
        _inputTableView.estimatedSectionHeaderHeight = 0;
        _inputTableView.estimatedSectionFooterHeight = 0;
        _inputTableView.delegate = self;
        _inputTableView.dataSource = self;
        [_inputTableView registerClass:[YASInputCell class] forCellReuseIdentifier:NSStringFromClass([YASInputCell class])];
    }
    return _inputTableView;
}

- (UIButton *)hiddenKeyboardButton
{
    if (!_hiddenKeyboardButton) {
        _hiddenKeyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hiddenKeyboardButton.frame = CGRectMake(0, 44, self.view.frame.size.width, 32);
        [_hiddenKeyboardButton setTitle:@"隐藏键盘" forState:UIControlStateNormal];
        [_hiddenKeyboardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_hiddenKeyboardButton addTarget:self action:@selector(changeTableViewInset) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hiddenKeyboardButton;
}

@end
