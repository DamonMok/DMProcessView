//
//  ViewController.m
//  DMProgressHUD
//
//  Created by Damon on 2017/10/23.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "ViewController.h"
#import "DMProgressHUD.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSArray *> *arrData;

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
        
        NSArray *arrLoading = @[@"Indicator", @"Indicator-带文字", @"circle", @"circle-带文字"];
        NSArray *arrProgress = @[@"Circle", @"Circel-带文字", @"Sector", @"Sector-带文字"];
        NSArray *arrStatus = [NSArray arrayWithObjects:@"【重构】成功提示", @"【重构】失败提示", @"【重构】警告提示", nil];
        NSArray *arrText = @[@"【重构】纯文字提示"];
        NSArray *arrCustom = @[@"【重构】自定义", @"【重构】自定义-带文字"];
        _arrData = [NSMutableArray arrayWithObjects:arrLoading ,arrProgress ,arrStatus, arrText,arrCustom, nil];
    }
    
    return _arrData;
}

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
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
        switch (indexPath.row) {
            case 0:
                [self showProgressLoadingTypeIndicator];
                break;
            case 1:
                [self showProgressLoadingTypeIndicatorWithText];
                break;
            case 2:
                [self showProgressLoadingTypeCircle];
                break;
            case 3:
                [self showProgressLoadingTypeCircleWithText];
                break;
                
            default:
                break;
        }
        
    }else if (indexPath.section == 1) {
        
        switch (indexPath.row) {
            case 0:
                [self showProgressTypeCircle];
                break;
            case 1:
                [self showProgressTypeCircleWithText];
                break;
            case 2:
                [self showProgressTypeSector];
                break;
            case 3:
                [self showProgressTypeSectorWithText];
                break;
                
            default:
                break;
        }
        
    } else if (indexPath.section == 2) {
        
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
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        
        switch (indexPath.row) {
            case 0:
                [self showProgressText];
                break;
                
            default:
                break;
        }
    } else if (indexPath.section == 4) {
        
        switch (indexPath.row) {
            case 0:
                [self showProgressCustom];
                break;
            case 1:
                [self showProgressCustomWithText];
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
            return @"Progress";
            break;
            
        case 2:
            return @"Status";
            break;
        case 3:
            return @"Text";
            break;
        case 4:
            return @"Custom";
            break;
            
        default:
            return @"";
            break;
    }
}


- (void)showProgressLoadingTypeIndicator {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view];
    hud.mode = DMProgressHUDModeLoading;
    //hud.insets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismissCompletion:^{
                
                NSLog(@"dismissCompletion");
            }];
        });
    });
}

- (void)showProgressLoadingTypeIndicatorWithText {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view maskType:DMProgressHUDMaskTypeGray];
    hud.style = DMProgressHUDStyleLight;
    hud.mode = DMProgressHUDModeLoading;
    hud.label.text = @"Loading...";
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressLoadingTypeCircle {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view];
    hud.mode = DMProgressHUDModeLoading;
    hud.loadingType = DMProgressHUDLoadingTypeCircle;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressLoadingTypeCircleWithText {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:DMProgressHUDAnimationIncrement];
    hud.mode = DMProgressHUDModeLoading;
    hud.loadingType = DMProgressHUDLoadingTypeCircle;
    hud.label.text = @"Loading...";
    hud.style = DMProgressHUDStyleLight;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressTypeCircle {
    
    DMProgressHUD *hud= [DMProgressHUD showHUDAddedTo:self.view maskType:DMProgressHUDMaskTypeGray];
    hud.mode = DMProgressHUDModeProgress;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressTypeCircleWithText {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:DMProgressHUDAnimationIncrement];
    hud.mode = DMProgressHUDModeProgress;
    hud.label.text = @"Loading...";
    hud.style = DMProgressHUDStyleLight;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressTypeSector {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view];
    hud.mode = DMProgressHUDModeProgress;
    hud.progressType = DMProgressHUDProgressTypeSector;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressTypeSectorWithText {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:DMProgressHUDAnimationIncrement];
    hud.mode = DMProgressHUDModeProgress;
    hud.progressType = DMProgressHUDProgressTypeSector;
    hud.label.text = @"Loading...";
    hud.style = DMProgressHUDStyleLight;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressStatusSuccess {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view];
    hud.mode = DMProgressHUDModeStatus;
    hud.statusType = DMProgressHUDStatusTypeSuccess;
    hud.label.text = @"Success status";
    [hud dismissAfter:1.0 completion:^{
        
        NSLog(@"complete");
    }];
}

- (void)showProgressStatusFail {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:DMProgressHUDAnimationIncrement];
    hud.style = DMProgressHUDStyleLight;
    hud.mode = DMProgressHUDModeStatus;
    hud.statusType = DMProgressHUDStatusTypeFail;
    hud.label.text = @"Fail status";
    
    [hud dismissAfter:1.0 completion:^{
        
        NSLog(@"complete");
    }];
}

- (void)showProgressStatusWarning {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:DMProgressHUDAnimationSpring maskType:DMProgressHUDMaskTypeGray maskTapHandle:^(DMProgressHUD *hud) {
        
        [hud dismissCompletion:^{
            
            NSLog(@"dismiss complete");
        }];
    }];
    hud.mode = DMProgressHUDModeStatus;
    hud.statusType = DMProgressHUDStatusTypeWarning;
    hud.label.text = @"Warning status";
}

- (void)showProgressText {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:DMProgressHUDAnimationSpring];
    hud.mode = DMProgressHUDModeText;
    hud.label.text = @"This is your text";
    hud.style = DMProgressHUDStyleLight;
    [hud dismissAfter:1.0];
}

- (void)showProgressCustom {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view];
    hud.mode = DMProgressHUDModeCustom;
    hud.label.text = @"";
    //custom
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"]];
    [hud setCustomView:view width:80 height:80];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)showProgressCustomWithText {
    
    DMProgressHUD *hud = [DMProgressHUD showHUDAddedTo:self.view animation:DMProgressHUDAnimationIncrement];
    hud.mode = DMProgressHUDModeCustom;
    hud.label.text = @"Custom with label";
    hud.style = DMProgressHUDStyleLight;
    
    //custom
    UIView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person"]];
    [hud setCustomView:view width:80 height:80];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self doSomething];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [hud dismiss];
        });
    });
}

- (void)doSomething {
    
    CGFloat progress = 0;
    
    while (progress < 1) {

        progress += 0.01;
        dispatch_async(dispatch_get_main_queue(), ^{
            //refresh progress-value on main thread
            DMProgressHUD *hud = [DMProgressHUD progressHUDForView:self.view];
            hud.progress = progress;
        });
        [NSThread sleepForTimeInterval:0.01];
    }
}

@end
