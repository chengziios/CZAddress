//
//  UIView+CZCategory.h
//  PQD
//
//  Created by 程健 on 2017/4/19.
//  Copyright © 2017年 程健. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface UIView (CZCategory)

- (void)addTarget:(id)target action:(SEL)action;
@end



@interface UIView (CZFrame)
@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize size;
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;
@property (nonatomic, assign) CGSize maxSize;

/*equal to view frame*/
- (void)topEqualToView:(UIView *)view;
- (void)bottomEqualToView:(UIView *)view;
- (void)leftEqualToView:(UIView *)view;
- (void)rightEqualToView:(UIView *)view;

- (void)heightEqualToView:(UIView *)view;
- (void)widthEqualToView:(UIView *)view;
- (void)sizeEqualToView:(UIView *)view;

- (void)centerXEqualToView:(UIView *)view;
- (void)centerYEqualToView:(UIView *)view;
- (void)centerEqualToView:(UIView *)view;

/*frame fromView*/
- (void)top:(CGFloat)top FromView:(UIView *)view;
- (void)bottom:(CGFloat)bottom FromView:(UIView *)view;
- (void)left:(CGFloat)left FromView:(UIView *)view;
- (void)right:(CGFloat)right FromView:(UIView *)view;

/*frame in container*/
- (void)topInContainer:(CGFloat)top shouldResize:(BOOL)shouldResize;
- (void)bottomInContainer:(CGFloat)bottom shouldResize:(BOOL)shouldResize;
- (void)leftInContainer:(CGFloat)left shouldResize:(BOOL)shouldResize;
- (void)rightInContainer:(CGFloat)right shouldResize:(BOOL)shouldResize;

// imbueset
- (void)fillWidth;
- (void)fillHeight;
- (void)fill;
- (UIView *)topSuperView;
@end




#define __AppViewStorageMaxCountL1 10
#define __AppViewStorageMaxCountL2 10

@interface UIView(Extensions)


@end


