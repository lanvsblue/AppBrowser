//
// Created by 蓝布鲁 on 2016/11/29.
// Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import "NSDictionary+LAN.h"
#import "NSArray+LAN.h"


@implementation NSDictionary (LAN)
+ (NSDictionary *)getDictionaryFromObject:(id)obj{
    NSMutableArray *superObjDic = [[NSMutableArray alloc] init];
    return [self getDictionary:obj objDic:superObjDic convertClass:[obj class]];
}

+(id)getDictionary:(id)obj objDic:(NSMutableArray *)superObjDic convertClass:(Class)convertClass{

    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *subObj = [NSMutableArray array];
        for (id o in obj) {
            [subObj addObject:[self getDictionary:o objDic:superObjDic convertClass:[o class]]];
        }
        return subObj;
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *subObj = [NSMutableDictionary dictionary];
        for (id o in [obj allKeys]) {
            subObj[o] = [self getDictionary:obj[o] objDic:superObjDic convertClass:[obj[o] class]];
        }
        return subObj;
    } else if ([obj isKindOfClass:[NSURL class]]){
        return [obj absoluteString];
    } else if ([obj isKindOfClass:[NSString class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSDate class]]) {
        return  [obj description];
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return  obj;
    } else if ([obj isKindOfClass:[NSUUID class]]) {
        return  [obj UUIDString];
    } else if ([[obj class] isSubclassOfClass:[NSObject class]] && ![obj isKindOfClass:NSClassFromString(@"OS_object")]) {
        //is analysis
        NSInteger index = [superObjDic indexOfObject:obj];
        if(index != NSNotFound&& [superObjDic[index] class]==convertClass){//if index found and class same
            return @{@"Command <<<":@(index)};
        } else {
            [superObjDic addObject:obj];
        }

        NSMutableDictionary *info = [[NSMutableDictionary alloc] init];

        //get all keys
        NSArray *allkeys = [NSArray getProperties:convertClass];
        for (NSString *key in allkeys) {
            //get value
            id value = [obj valueForKey:key];

            //show class name
            NSString *displayKey = [NSString stringWithFormat:@"%@ : %@",key, [value class]];
            info[key] = [self getDictionary:value objDic:superObjDic convertClass:[value class]];
        }

        //get super class info
        Class objSuperClass = [convertClass superclass];
        if(objSuperClass!=[NSObject class]){
            NSString *displayKey = [NSString stringWithFormat:@"%@ : %@",SUPER_CLASS, objSuperClass];
            info[SUPER_CLASS] = [self getDictionary:obj objDic:superObjDic convertClass:objSuperClass];
        }


        return info;
    }
    return nil;
}

@end