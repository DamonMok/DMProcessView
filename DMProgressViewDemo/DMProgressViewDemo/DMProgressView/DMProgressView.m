//
//  DMProgressView.m
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import "DMProgressView.h"

#define padding 20

@interface DMProgressView ()

//进度圈View
@property (nonatomic, strong)CAShapeLayer *processLayer;
@property (nonatomic, strong)UILabel *labProcess;

//加载中loadingView
@property (nonatomic, strong)UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong)UILabel *labLoading;

#warning recode
@property (nonatomic, strong) UIView *vBackground;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;

@end

@implementation DMProgressView

- (CAShapeLayer *)processLayer {
    
    if (!_processLayer) {
        
        _processLayer = [[CAShapeLayer alloc] init];
        _processLayer.lineWidth = 2.0;
        _processLayer.strokeColor = [[UIColor whiteColor] CGColor];
        _processLayer.fillColor = [[UIColor clearColor] CGColor];
        
        [self.layer addSublayer:self.processLayer];
    }
    
    return _processLayer;
}

- (UILabel *)labProcess {
    
    if (!_labProcess) {
        
        _labProcess = [[UILabel alloc] init];
        _labProcess.textColor = [UIColor whiteColor];
        _labProcess.textAlignment = NSTextAlignmentCenter;
        [_labProcess sizeToFit];
        
        [self.layer addSublayer:_labProcess.layer];
    }
    
    return _labProcess;
}

- (void)drawRect:(CGRect)rect {
    
    CGPoint center = CGPointMake(rect.size.width*0.5, rect.size.height*0.5);
    CGFloat radius = rect.size.width*0.5;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:3*M_PI_2 endAngle:3*M_PI_2+2*M_PI*self.process clockwise:YES];
    self.processLayer.path = [path CGPath];
    
    self.labProcess.frame = CGRectMake(0, 0, rect.size.width, rect.size.height*0.5);
    self.labProcess.center = center;
    self.labProcess.text = [NSString stringWithFormat:@"%.0f", self.process*100];
    
    self.labProcess.hidden = self.process>0?NO:YES;
    
}

- (void)setProcess:(CGFloat)process {
    
    _process = process;
    
    //2%预显示
    _process = _process > 0.02 ? _process : 0.02;
    
    [self setNeedsDisplay];
    
}

#pragma mark - 进度View
//【显示】进度View
+ (instancetype)showProgressViewAddedTo1:(UIView *)view {
    
    for (DMProgressView *progressView in view.subviews) {
        
        if ([progressView isKindOfClass:[DMProgressView class]]) {
            
            //[progressView removeFromSuperview];
            return progressView;
        }
    }
    
    DMProgressView *progressView = [[self alloc] init];
    progressView.backgroundColor = [UIColor clearColor];
    
    progressView.frame = CGRectMake(0, 0, 40, 40);
    progressView.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5);
    
    [view addSubview:progressView];
    
    return progressView;
}

//【隐藏】进度View
- (void)hideProgressView {
    
    [self.labProcess.layer removeFromSuperlayer];
    [self removeFromSuperview];

}

#pragma mark - 加载View
//【显示】loadingView
+ (instancetype)showLoadingViewAddTo1:(UIView *)view {

    for (DMProgressView *loadingView in view.subviews) {
        
        if ([loadingView isKindOfClass:[DMProgressView class]]) {
            
            return loadingView;
        }
    }
    
    DMProgressView *progressView = [[DMProgressView alloc] init];
    progressView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
    progressView.layer.masksToBounds = YES;
    progressView.layer.cornerRadius = 5;
    progressView.frame = CGRectMake(0, 0, 100, 100);
    progressView.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5);
    
    //加载圈
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    progressView.activityIndicatorView = activityIndicatorView;
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    activityIndicatorView.center = CGPointMake(progressView.bounds.size.width*0.5, progressView.bounds.size.height*0.5-15);
    
    [activityIndicatorView startAnimating];
    
    //文字
    UILabel *labLoading = [[UILabel alloc] init];
    progressView.labLoading = labLoading;
    labLoading.text = @"正在加载...";
    labLoading.font = [UIFont systemFontOfSize:14.0];
    labLoading.textColor = [UIColor whiteColor];
    labLoading.textAlignment = NSTextAlignmentCenter;
    [labLoading sizeToFit];
    labLoading.frame = CGRectMake(0, 0, progressView.bounds.size.width, 30);
    labLoading.center = CGPointMake(progressView.bounds.size.width*0.5, progressView.bounds.size.height*0.5+30);
    
    [view addSubview:progressView];
    [progressView addSubview:activityIndicatorView];
    [progressView addSubview:labLoading];
    
    return progressView;
}


//【隐藏】loadingView
- (void)hideLoadingView {

    [self removeFromSuperview];
}

#pragma mark - 成功提示View
//【显示
+ (instancetype)showSuccessAddedTo:(UIView *)view message:(NSString *)message {

    for (DMProgressView *loadingView in view.subviews) {
        
        if ([loadingView isKindOfClass:[DMProgressView class]]) {
            
            return loadingView;
        }
    }
    
    DMProgressView *progressView = [[DMProgressView alloc] init];
    progressView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
    progressView.layer.masksToBounds = YES;
    progressView.layer.cornerRadius = 5;
    progressView.frame = CGRectMake(0, 0, 100, 100);
    progressView.center = CGPointMake(view.bounds.size.width*0.5, view.bounds.size.height*0.5);
    progressView.alpha = 0;
    
    //成功图标
    UIImageView *ivSuccess = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProgressSuccess"]];
    ivSuccess.frame = CGRectMake(0, 0, 35, 35);
    ivSuccess.center = CGPointMake(progressView.bounds.size.width*0.5, progressView.bounds.size.height*0.5-15);
    
    //文字
    UILabel *labLoading = [[UILabel alloc] init];
    progressView.labLoading = labLoading;
    labLoading.text = message;
    labLoading.font = [UIFont systemFontOfSize:14.0];
    labLoading.textColor = [UIColor whiteColor];
    labLoading.textAlignment = NSTextAlignmentCenter;
    [labLoading sizeToFit];
    labLoading.frame = CGRectMake(0, 0, progressView.bounds.size.width, 30);
    labLoading.center = CGPointMake(progressView.bounds.size.width*0.5, progressView.bounds.size.height*0.5+30);
    
    [progressView addSubview:ivSuccess];
    [progressView addSubview:labLoading];
    [view addSubview:progressView];
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        progressView.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [progressView hideSuccessWithView:view];
        });
    }];
    
    return progressView;
}

//【隐藏】成功提示
- (void)hideSuccessWithView:(UIView *)view {
    
    [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

#warning recode
+ (instancetype)showProgressViewAddedTo:(UIView *)view {

    DMProgressView *progressView = [[self alloc] p_initWithView:view];
    progressView.backgroundColor = [UIColor clearColor];
    [view addSubview:progressView];
    
    [progressView p_show];
    
    return progressView;
}

- (id)p_initWithView:(UIView *)view {

    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self p_configCommon];
    }
    
    return self;
}

- (void)p_configCommon {
    
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0;
    _margin = 20;
    
    [self p_setUpConponents];
    [self p_updateConstraints];
}

- (void)p_setUpConponents {
    
    //Background view
    self.vBackground = [[UIView alloc] init];
    self.vBackground.translatesAutoresizingMaskIntoConstraints = NO;
    self.vBackground.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
    self.vBackground.layer.cornerRadius = 5;
    self.vBackground.layer.masksToBounds = YES;
    [self addSubview:self.vBackground];
    
    //Custom view
    _customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ProgressSuccess"]];
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Text label
    self.label = [[UILabel alloc] init];
    self.label.translatesAutoresizingMaskIntoConstraints = NO;
    self.label.text = @"Loading Loading";
    self.label.textColor = [UIColor whiteColor];
    self.label.font = [UIFont systemFontOfSize:16.0];
    [_vBackground addSubview:self.label];
    
    //UIActivityIndicatorView
    _indicator = [[UIActivityIndicatorView alloc] init];
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_indicator startAnimating];
    
}

- (void)p_updateConstraints {

    //background view
    NSMutableArray *bgConstraints = [NSMutableArray new];
    [bgConstraints addObject:[NSLayoutConstraint constraintWithItem:_vBackground attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [bgConstraints addObject:[NSLayoutConstraint constraintWithItem:_vBackground attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [bgConstraints addObject:[NSLayoutConstraint constraintWithItem:_vBackground attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:-_margin]];
    [bgConstraints addObject:[NSLayoutConstraint constraintWithItem:_vBackground attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1 constant:-_margin]];
    [self addConstraints:bgConstraints];
    
    if (_mode == DMProgressViewModeLoading) {
        
        NSLog(@"DMProgressViewModeLoading");
        [_vBackground addSubview:_customView];
        //[_customView addSubview:_indicator];
        
        NSMutableArray *cusViewConstraints = [NSMutableArray new];
        [cusViewConstraints addObject:[NSLayoutConstraint constraintWithItem:_customView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_vBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self configConstraints:cusViewConstraints forSubView:_customView minimumWidth:22 minimumHeight:22];
        [self updateBgViewWithTopView:_customView bottomView:_customView widthView:_customView];
        [_vBackground addConstraints:cusViewConstraints];
        
        
    } else if (_mode == DMProgressViewModeProgress) {
    
        NSLog(@"DMProgressViewModeProgress");
    
    } else if (_mode == DMProgressViewModeStatus) {
    
        NSLog(@"DMProgressViewModeStatus");
    
    } else if (_mode == DMProgressViewModeText) {
    
        [_customView removeFromSuperview];
        [_vBackground addSubview:_label];
        //label
        NSMutableArray *labConstraints = [NSMutableArray new];
        [labConstraints addObject:[NSLayoutConstraint constraintWithItem:_label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_vBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self updateBgViewWithTopView:_label bottomView:_label widthView:_label];
        [_vBackground addConstraints:labConstraints];
    }
}

- (void)p_show {

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                
                self.alpha = 0;
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
            }];
        });
    }];
}


- (void)setMode:(DMProgressViewMode)mode {

    _mode = mode;
    
    [self p_updateConstraints];
}


- (void)configConstraints:(NSMutableArray *)constraints forSubView:(UIView *)subView minimumWidth:(CGFloat)width minimumHeight:(CGFloat)height {

    [constraints addObject:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:_vBackground attribute:NSLayoutAttributeWidth multiplier:1 constant:-padding]];
    [constraints addObject:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:_vBackground attribute:NSLayoutAttributeHeight multiplier:1 constant:-padding]];
    [subView addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width]];
    [subView addConstraint:[NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height]];
}

- (void)updateBgViewWithTopView:(UIView *)topView bottomView:(UIView *)bottomView widthView:(UIView *)widthView {

    [_vBackground addConstraint:[NSLayoutConstraint constraintWithItem:_vBackground attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeTop multiplier:1 constant:-padding]];
    [_vBackground addConstraint:[NSLayoutConstraint constraintWithItem:_vBackground attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:bottomView attribute:NSLayoutAttributeBottom multiplier:1 constant:padding]];
    [_vBackground addConstraint:[NSLayoutConstraint constraintWithItem:_vBackground attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:widthView attribute:NSLayoutAttributeWidth multiplier:1 constant:2*padding]];
}








- (void)dealloc {

    NSLog(@"%s", __func__);
}

@end
