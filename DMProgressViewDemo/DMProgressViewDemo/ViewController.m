//
//  ViewController.m
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "ViewController.h"
#import "DMProgressView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    int _index;
}

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<NSArray *> *arrData;

@end

@implementation ViewController

#pragma mark - lazy load
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}

- (NSMutableArray *)arrData {
    
    if (!_arrData) {
        
        NSArray *arrLoading = @[@"Loading"];
        NSArray *arrStatus = [NSArray arrayWithObjects:@"【重构】成功提示", @"【重构】失败提示", @"【重构】警告提示", @"【重构】自定义",nil];
        NSArray *arrText = @[@"【重构】纯文字提示"];
        
        _arrData = [NSMutableArray arrayWithObjects:arrLoading ,arrStatus, arrText, nil];
    }
    
    return _arrData;
}

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, 22, self.view.bounds.size.width, self.view.bounds.size.height-22);
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrData[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reusedId = @"Hub";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedId];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedId];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:.1f alpha:0.1];
    
    NSArray *arrDetail = _arrData[indexPath.section];
    NSString *strText = arrDetail[indexPath.row];
    
    cell.textLabel.text = strText;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:!cell.selected animated:YES];
    
    if (indexPath.section == 0) {
        [self showProgressLoading];
        
    } else if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
                [self showProgressStatusSuccess];
                break;
            case 1:
                [self showProgressStatusFail];
                break;
            case 2:
                [self showProgressStatusWarning];
                break;
            case 3:
                [self showCustomView];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 2) {
    
        switch (indexPath.row) {
            case 0:
                [self showProgressText];
                break;
                
            default:
                break;
        }
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch (section) {
        case 0:
            return @"Loading";
            break;
        
        case 1:
            return @"Status";
            break;
        case 2:
            return @"Text";
            break;
            
        default:
            return @"";
            break;
    }
}

#pragma mark 进度圈
- (void)showProgressView {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    
    NSArray *arrProcess = @[@0, @0.2, @0.4, @0.6, @0.8, @1.0];
    
    __block int i = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.25 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (i < arrProcess.count) {
            
            progressView.process = [arrProcess[i] doubleValue];
            i++;
        } else {
            
            [timer invalidate];
            [progressView hideProgressView];
        }
    }];
}

#pragma mark 加载中
- (void)showLoadingView {
    
    DMProgressView *progressView = [DMProgressView showLoadingViewAddTo1:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [progressView hideLoadingView];
    });
}

#pragma mark 成功提示
- (void)showSuccessView {
    
    [DMProgressView showSuccessAddedTo:self.view message:@"保存成功"];
    
}

#warning recode
- (void)showProgressLoading {

    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeLoading;
}

- (void)showProgressStatusSuccess {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.status = DMProgressViewStatusSuccess;
    progressView.label.text = @"Success status";
}

- (void)showProgressStatusFail {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.status = DMProgressViewStatusFail;
    progressView.label.text = @"Fail status";
}

- (void)showProgressStatusWarning {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.status = DMProgressViewStatusWarning;
    progressView.label.text = @"Warning status";
}

- (void)showProgressText {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeText;
    progressView.label.text = @"This is your textThis is your textThis is your textThis is your textThis is your text";
}

- (void)showCustomView {
    
    DMProgressView *progressView = [DMProgressView showProgressViewAddedTo:self.view];
    progressView.mode = DMProgressViewModeStatus;
    progressView.label.text = @"Custom view";
    
    //custom
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"]];
    [progressView setCustomView:view width:80 height:80];
}


@end
