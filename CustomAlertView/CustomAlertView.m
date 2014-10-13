//
//  CustomAlertView.m
//  CustomAlertView
//
//  Created by udspj on 14-9-15.
//  Copyright (c) 2014年 Wangdi. All rights reserved.
//

#import "CustomAlertView.h"

@interface CustomAlertView ()

@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, strong) UIView *hudView;//用于显示的view

@property (nonatomic, strong) UIImageView *imageView;//图片的大小为 传入图片的尺寸
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) NSArray *buttonArray;

//- (CGFloat)getHeight;

@end

@implementation CustomAlertView

#pragma mark - initMethod
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        self.messageColor = [UIColor colorWithRed:45/225.0f  green:62/225.0f blue:80/225.0f alpha:1];
        self.titleColor = [UIColor colorWithRed:45/225.0f  green:62/225.0f blue:80/225.0f alpha:1];
        self.messageFont = [UIFont systemFontOfSize:12.0];
        self.titleFont = [UIFont systemFontOfSize:12.0];
        
        self.alpha = 0;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                        image:(UIImage *)image
                     delegate:(id<CustomAlertViewDelegate>)delegate
                      buttons:(NSArray *)buttons
{
    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self)
    {
        self.title = title;
        self.message = message;
        self.image = image;
        self.delegate = delegate;
        self.buttonStrArray = buttons;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor colorWithWhite:0 alpha:0.5] set];
    CGContextFillRect(context, self.bounds);
}

#pragma mark - property
- (UIControl *)overlayView
{
    if (_overlayView == nil)
    {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}

//- (CGFloat)getHeight
//{
//    CGFloat height = 0.0;
//    if (self.image != nil)
//    {
//        height += 23 + self.image.size.height;
//    }
//    if (self.title != nil)
//    {
//        CGSize stringSize = [self.title sizeWithFont:self.titleFont constrainedToSize:CGSizeMake(AlertViewWidth - 60, 300)];//因暂未做太多字数的考虑 此处给300
//        height += 23  + stringSize.height;
//    }
//    if (self.message != nil)
//    {
//        CGSize stringSize = [self.message sizeWithFont:self.messageFont constrainedToSize:CGSizeMake(AlertViewWidth -60, 300)];
//        height += 21 + stringSize.height;
//    }
//    if (self.buttonStrArray != nil && self.buttonStrArray.count > 0)
//    {
//        height += 24 + 43 + 23;//43 按钮的高度, 23按钮到底部的高度.
//    }
//    return height;
//}

- (void)updateView
{
    if (_hudView == nil)
    {
        _hudView = [[UIView alloc] init];
        [_hudView setBackgroundColor:[UIColor whiteColor]];
        _hudView.layer.cornerRadius = 8;
        _hudView.layer.masksToBounds = YES;
        
        if ([_hudView respondsToSelector:@selector(addMotionEffect:)]) {
            UIInterpolatingMotionEffect *effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.x" type: UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
            effectX.minimumRelativeValue = @(-10);
            effectX.maximumRelativeValue = @(10);
            
            UIInterpolatingMotionEffect *effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath: @"center.y" type: UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
            effectY.minimumRelativeValue = @(-10);
            effectY.maximumRelativeValue = @(10);
            
            [_hudView addMotionEffect: effectX];
            [_hudView addMotionEffect: effectY];
        }
        
        [self addSubview:_hudView];
    }
    
    CGFloat currentHeight = 0.0;//当前的高度
    //设置图片
    if (self.image != nil)
    {
        if (_imageView == nil)
        {
            _imageView = [[UIImageView alloc] init];
            [_imageView setBackgroundColor:[UIColor clearColor]];
            [_hudView addSubview:_imageView];
        }
        
        [_imageView setHidden:NO];
        [_imageView setImage:self.image];
        _imageView.frame = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
        _imageView.center = CGPointMake(AlertViewWidth/2, 23 + self.image.size.height/2);
        currentHeight = 23 + self.image.size.height;
    }
    else
    {
        [_imageView setHidden:YES];
    }
    //设置标题
    if (self.title != nil)
    {
        if (_titleLabel == nil)
        {
            _titleLabel = [[UILabel alloc] init];
            [_titleLabel setBackgroundColor:[UIColor clearColor]];
            [_titleLabel setTextAlignment:NSTextAlignmentCenter];
            [_titleLabel setNumberOfLines:0];
            [_hudView addSubview:_titleLabel];
        }
        
        [_titleLabel setTextColor:self.titleColor];
        [_titleLabel setFont:self.titleFont];
//        [_titleLabel setText:self.title];
        _titleLabel.attributedText = [CustomAlertView getAttributeStr:self.title
                                                      lineSpaceHeight:6
                                                             textFont:self.titleFont
                                                            textColor:self.titleColor];
        [_titleLabel sizeToFit];
        
        _titleLabel.center = CGPointMake(AlertViewWidth/2, currentHeight + 23 + _titleLabel.frame.size.height / 2);
        currentHeight += 23 + _titleLabel.frame.size.height;
    }
    else
    {
        [_titleLabel setHidden:YES];
    }
    
    //设置内容
    if (self.message != nil)
    {
        if (_messageLabel == nil)
        {
            _messageLabel = [[UILabel alloc] init];
            [_messageLabel setBackgroundColor:[UIColor clearColor]];
            [_messageLabel setTextAlignment:NSTextAlignmentCenter];
            [_messageLabel setNumberOfLines:0];
            [_hudView addSubview:_messageLabel];
        }
        
        [_messageLabel setTextColor:self.messageColor];
        [_messageLabel setFont:self.messageFont];
//        [_messageLabel setText:self.message];
        _messageLabel.attributedText = [CustomAlertView getAttributeStr:self.message
                                                        lineSpaceHeight:6
                                                               textFont:self.messageFont
                                                              textColor:self.messageColor];
        [_messageLabel sizeToFit];
        
        _messageLabel.center = CGPointMake(AlertViewWidth/2, currentHeight + 21 + _messageLabel.frame.size.height / 2);
        currentHeight += 23 + _messageLabel.frame.size.height;
    }
    else
    {
        [_messageLabel setHidden:YES];
    }
    
    //初始换按钮;按钮的全部重置;目前只考虑最多2个的情况
    if (self.buttonStrArray != nil && self.buttonStrArray.count > 0)
    {
        NSInteger btnCount = self.buttonStrArray.count;
        
        CGFloat btnWidth;//每个按钮的宽度
        if (btnCount < 3)
        {
            btnWidth = (AlertViewWidth - 60 - (btnCount - 1) * 20)/btnCount;
            int currentIndex = 0;
            for (NSString *tempBtnStr in self.buttonStrArray)
            {
                if (![tempBtnStr isKindOfClass:[NSString class]])
                {
                    continue;
                }
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:@"button_up.png"] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn.titleLabel setFont:[UIFont systemFontOfSize:18]];
                [btn setFrame:CGRectMake(30 + (btnWidth + 20) * currentIndex, currentHeight + 24, btnWidth, 43)];
                [btn setTitle:tempBtnStr forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(alertDidClick:) forControlEvents:UIControlEventTouchUpInside];
                [btn setTag:currentIndex];
                [_hudView addSubview:btn];
                
                currentIndex++;
            }
            currentHeight += 24 + 43 + 23;
        }
        else
        {
            btnCount = AlertViewWidth - 60;
            //TODO：
        }
    }
    
    [_hudView setFrame:CGRectMake(0, 0, AlertViewWidth, currentHeight)];
    [_hudView setCenter:self.center];
}

- (void)alertDidClick:(UIButton *)sender
{
    [self dismissWithClickButtonIndex:sender.tag];
}

#pragma mark - showMethod
- (void)showAlertView
{
    [self updateView];
    
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication]windows]reverseObjectEnumerator];
        
        for (UIWindow *window in frontToBackWindows)
            if (window.windowLevel == UIWindowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
    }
    
    if (self.subviews)
    {
        [self.overlayView addSubview:self];
    }
    
    if (self.alpha != 1)//当前是隐藏状态
    {
//        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
        
        [UIView animateWithDuration:0.15
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
//                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/0.8, 1/0.8);
                             
                             self.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        self.hudView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        
        CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        bounceAnimation.values = @[@0.9,@1.05,@0.95,@1];
        bounceAnimation.duration = 0.3;
//        bounceAnimation.removedOnCompletion = NO;
        [self.hudView.layer addAnimation:bounceAnimation forKey:@"bounce"];
        self.hudView.layer.transform = CATransform3DIdentity;
    }
    [self setNeedsDisplay];
}

- (void)dismissWithClickButtonIndex:(NSInteger)buttonIndex
{
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 0.8, 0.8);
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];//必须加上这句，否则无法释放
                         [_overlayView removeFromSuperview];
                     }];
    if (self.delegate && [self.delegate respondsToSelector:@selector(customAlertView:didClickWithIndex:)])
    {
        [self.delegate customAlertView:self didClickWithIndex:buttonIndex];
    }
}

- (void)dealloc
{
    NSLog(@"deacllo");
}

+ (NSAttributedString *)getAttributeStr:(NSString *)str
                        lineSpaceHeight:(CGFloat)lineSqace
                               textFont:(UIFont *)font
                              textColor:(UIColor *)color
{
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSqace];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];

    NSDictionary *dic = @{NSParagraphStyleAttributeName:paragraphStyle,
                          NSFontAttributeName:font,
                          NSForegroundColorAttributeName:color};
    [attr addAttributes:dic range:NSMakeRange(0, str.length)];
    
    return attr;
}


@end
