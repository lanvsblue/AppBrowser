//
// Created by 蓝布鲁 on 16/7/16.
// Copyright (c) 2016 lanvsblue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (LAN)

/*
 * @brief 视图左侧X轴坐标
 * getters: UIView.frame.origin.x
 * setters: UIView.frame.origin.x = originX
 */
@property (nonatomic, assign) CGFloat originX;

/*
 * @brief 视图顶部Y轴坐标
 * getters: UIView.frame.origin.y
 * setters: UIView.frame.origin.y = originY
 */
@property (nonatomic, assign) CGFloat originY;

/*
 * @brief 视图右侧X轴坐标
 * getters: UIView.frame.origin.x + UIView.frame.size.width
 * setters: UIView.frame.origin.x = rightX - UIView.frame.size.width
 */
@property (nonatomic, assign) CGFloat rightX;

/*
 * @brief 视图下方Y轴坐标
 * getters: UIView.frame.origin.y + UIView.frame.size.height
 * setters: UIView.frame.origin.y = bottomY - UIView.frame.size.height
 */
@property (nonatomic, assign) CGFloat bottomY;

/*
 * @brief 视图高度
 * getters: UIView.frame.size.height
 * setters: UIView.frame.size.height = height
 */
@property (nonatomic, assign) CGFloat height;

/*
 * @brief 视图宽度
 * getters: UIView.frame.size.width
 * setters: UIView.frame.size.width = width
 */


@property (nonatomic, assign)CGFloat width;

/*
 * 获取当前view所在的viewController
 */
@property (nonatomic, readonly) UIViewController *viewController;


/*
 * 移除所有的子View
 */
- (void)removeAllSubviews;

/*
 * 移除数组中所有的子View
 */
-(void)removeSubViews:(NSArray *)views;



/*
 * 不响应父类的事件
 */
-(void)noActionForSuperEvent;

@end