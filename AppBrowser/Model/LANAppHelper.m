//
// Created by 蓝布鲁 on 2016/11/24.
// Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import "LANAppHelper.h"
#import "NSArray+LAN.h"
#import "NSDictionary+LAN.h"


@implementation LANAppHelper {

}
+ (id)defaultWorkspace {
    return [@"LSApplicationWorkspace" invokeClassMethod:@"defaultWorkspace"];
}

+ (id)allInstalledApplications {
    return [[self defaultWorkspace] invoke:@"allInstalledApplications"];
}

+ (BOOL)openApplication:(id)application {
    return [[self defaultWorkspace] invoke:@"openApplicationWithBundleID:" args:[self bundleIdentifierForApplication:application],nil];
}

+ (BOOL)removeApplication:(id)application {
    
    #if TARGET_IPHONE_SIMULATOR
    return [[self defaultWorkspace] invoke:@"uninstallApplication:withOptions:" args:[application bundleIdentifier],nil,nil];
    #elif TARGET_OS_IPHONE//真机
    return false;
    #endif
    
}


+ (id)nameForApplication:(id)application {
    return [([application valueForKeyPath:APP_NAME_KEY_PATH] ?: [application valueForKeyPath:APP_SHORT_NAME_KEY_PATH]) description];
}

+(id)bundleIdentifierForApplication:(id)application{
    return [application valueForKey:@"bundleIdentifier"];
}

+ (id)iconForApplication:(id)application {
    return [UIImage invoke:@"_applicationIconImageForBundleIdentifier:format:scale:"
                      args:[application bundleIdentifier],@"",@3,nil];
}

+ (id)vendorNameForApplication:(id)application {
    return [[self appTypeForApplication:application] isEqualToString:@"System"]? @"Apple":[application valueForKey:@"vendorName"];
}

+ (id)appTypeForApplication:(id)application {
    return [application valueForKey:@"applicationType"];
}

+ (id)bundleIDForApplication:(id)application {
    return [application valueForKeyPath:APP_BUNDLE_ID_KEY_PATH];
}


+(NSDictionary *)infoForApplication:(id)application{
    return [NSDictionary getDictionaryFromObject:application];
}



@end
