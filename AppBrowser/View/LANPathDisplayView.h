//
//  LANPathDisplayView.h
//  AppBrowser
//
//  Created by 蓝布鲁 on 2016/11/30.
//  Copyright (c) 2016 lanvsblueCO. All rights reserved.
//



@interface LANPathDisplayView : UIView

@property (nonatomic, retain)NSString *displayPath;

-(NSString *)setDisplayPath:(NSString *)disPath addPath:(NSString *)addPath;

-(void)setupView;

@end
