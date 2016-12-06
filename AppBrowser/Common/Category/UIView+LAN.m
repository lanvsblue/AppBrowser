//
// Created by 蓝布鲁 on 16/7/16.
// Copyright (c) 2016 lanvsblue. All rights reserved.
//

#import <objc/runtime.h>
#import "UIView+LAN.h"




@implementation UIView (LAN)

- (CGFloat)originX {
    return self.frame.origin.x;
}

- (void)setOriginX:(CGFloat)originX {
    CGRect frame = self.frame;
    frame.origin.x = originX;
    self.frame = frame;
}

- (CGFloat)originY {
    return self.frame.origin.y;
}

- (void)setOriginY:(CGFloat)originY {
    CGRect frame = self.frame;
    frame.origin.y = originY;
    self.frame = frame;
}

- (CGFloat)rightX {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRightX:(CGFloat)rightX {
    CGRect frame = self.frame;
    frame.origin.x = rightX - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottomY {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottomY:(CGFloat)bottomY {
    CGRect frame = self.frame;
    frame.origin.y = bottomY - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.width = height;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

-(void)removeSubViews:(NSArray *)views{
    for (UIView *view in views) {
        [view removeFromSuperview];
    }
}

- (void)noActionForSuperEvent {
    UITapGestureRecognizer *forbidSuperGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    [self addGestureRecognizer:forbidSuperGesture];
}


@end