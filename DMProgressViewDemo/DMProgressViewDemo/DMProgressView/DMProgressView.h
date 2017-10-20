//
//  DMProgressView.h
//  DMProgressViewDemo
//
//  Created by Damon on 2017/9/1.
//  Copyright © 2017年 damon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DMProgressViewMode) {

    DMProgressViewModeLoading,

    DMProgressViewModeProgress,
    
    DMProgressViewModeStatus,
    
    DMProgressViewModeText
};

typedef NS_ENUM(NSInteger, DMProgressViewStatus) {

    DMProgressViewStatusSuccess,
    
    DMProgressViewStatusFail,
    
    DMProgressViewStatusWarning
    
};

@interface DMProgressView : UIView

//process
@property (nonatomic, assign)CGFloat process;

//---------------------进度---------------------
/**【显示】进度View*/
+ (instancetype)showProgressViewAddedTo1:(UIView *)view;

/**【隐藏】进度View*/
- (void)hideProgressView;

//---------------------加载中---------------------
/**【显示】loadingView*/
+ (instancetype)showLoadingViewAddTo1:(UIView *)view;

/**【隐藏】loadingView*/
- (void)hideLoadingView;

//---------------------成功提示---------------------
/**【显示】*/
+ (instancetype)showSuccessAddedTo:(UIView *)view message:(NSString *)message;



#warning recode
@property (nonatomic, assign) DMProgressViewMode mode;

@property (nonatomic, assign) DMProgressViewStatus status;

@property (nonatomic, strong) UIView *customView;

@property (nonatomic, strong, readonly) UILabel *label;

@property (nonatomic, assign) CGFloat margin;

+ (instancetype)showProgressViewAddedTo:(UIView *)view;

//custom view
- (void)setCustomView:(UIView *)view width:(CGFloat)width height:(CGFloat)height;

@end
