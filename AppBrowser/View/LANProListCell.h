//
//  LANProListCell.h
//  AppBrowser
//
//  Created by 蓝布鲁 on 2016/11/30.
//  Copyright (c) 2016 lanvsblueCO. All rights reserved.
//



@interface LANProListCell : UITableViewCell
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *subTitle;
@property(nonatomic, assign) UITableViewCellAccessoryType type;
@property (nonatomic, assign) NSInteger itemCount;
@property(nonatomic, assign) BOOL isFavorite;
@end
