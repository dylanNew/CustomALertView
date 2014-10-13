//
//  CustomAlertView.h
//  CustomAlertView
//
//  Created by udspj on 14-9-15.
//  Copyright (c) 2014年 Wangdi. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 
//提示框的宽度，其高度 由内容确定
#define AlertViewWidth 293



@class CustomAlertView;
@protocol CustomAlertViewDelegate <NSObject>

- (void)customAlertView:(CustomAlertView *)alertView didClickWithIndex:(NSInteger)index;

@end



@interface CustomAlertView : UIView


@property (nonatomic, strong) UIFont *titleFont;//default 12；
@property (nonatomic, strong) UIFont *messageFont;//default 12；
@property (nonatomic, strong) UIColor *titleColor;//default  RGB(45,62,80)
@property (nonatomic, strong) UIColor *messageColor;//default RGB(45,62,80)

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSArray *buttonStrArray;
@property (nonatomic, weak) id<CustomAlertViewDelegate> delegate;



- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        image:(UIImage *)image
                     delegate:(id<CustomAlertViewDelegate>)delegate
                      buttons:(NSArray *)buttons;
- (void)showAlertView;
- (void)dismissWithClickButtonIndex:(NSInteger)buttonIndex;

@end
