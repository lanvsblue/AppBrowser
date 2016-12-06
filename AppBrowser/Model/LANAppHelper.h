//
// Created by 蓝布鲁 on 2016/11/24.
// Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LANAppHelper : NSObject

// operate
+(id)defaultWorkspace;

+(id)allInstalledApplications;

+(BOOL)openApplication:(id)application;

+(BOOL)removeApplication:(id)application;


// get app info
+(id)nameForApplication:(id)application;

+(id)iconForApplication:(id)application;

+(id)vendorNameForApplication:(id)application;

+(id)appTypeForApplication:(id)application;

+(id)bundleIDForApplication:(id)application;

+(NSDictionary *)infoForApplication:(id)application;

@end