//
//  LANProListViewController.h
//  AppBrowser
//
//  Created by 蓝布鲁 on 2016/11/29.
//  Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

@class LANPathDisplayView;
typedef NS_ENUM(NSInteger,LANPropertiesType) {
    LANPropertiesTypeArray = 1,
    LANPropertiesTypeDictionary,
    LANPropertiesTypeKeyDict,
    LANPropertiesTypeValue
};

typedef void (^LANItemInfoFetchBlock)(UITableViewCellAccessoryType accessoryType, NSString *title, NSString *subtitle);


@interface LANProListViewController : UIViewController

-(id)initWithProperties:(id)properties;

@property (nonatomic, retain)LANPathDisplayView *pathDisplayView;

@end
