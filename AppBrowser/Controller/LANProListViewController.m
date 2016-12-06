//
//  LANProListViewController.m
//  AppBrowser
//
//  Created by 蓝布鲁 on 2016/11/29.
//  Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import "LANProListViewController.h"
#import "LANProListCell.h"
#import "LANPathDisplayView.h"
#import "NSDictionary+LAN.h"

@interface LANProListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, retain) UITableView *tableView;


@end

@implementation LANProListViewController{
    NSDictionary * _properties;
    NSArray *_allKeys;
}

- (id)initWithProperties:(id)properties {
    if(self=[super init]){
        if([properties isKindOfClass:[NSDictionary class]]){
            _allKeys = [properties allKeys];
            _properties = properties;
        } else if ([properties isKindOfClass:[NSArray class]]){
            _allKeys = properties;
        }

        //sort keys
        _allKeys = [_allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            if([obj1 isKindOfClass:[NSString class]]){

                //top item is super class
                if([obj1 isEqualToString:SUPER_CLASS]){
                    return NSOrderedAscending;
                } else if([obj2 isEqualToString:SUPER_CLASS]){
                    return NSOrderedDescending;
                }
                return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
            } else if ([obj1 isKindOfClass:[NSNumber class]]){
                return [obj1 compare:obj2];
            }
            return NSOrderedSame;

        }];
    }

    [self initDisplayView];
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //init tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT-20) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];

    [self.pathDisplayView setupView];
    [self.view addSubview:self.pathDisplayView];

    //init menu
//    UIMenuItem *favoriteItem = [[UIMenuItem alloc] initWithTitle:@"Favorite" action:@selector(favoriteItem:)];
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    [menuController setMenuItems:@[favoriteItem]];
//    [menuController update];
}

-(void)initDisplayView{
    //init pathDisplayView
    self.pathDisplayView = [[LANPathDisplayView alloc] initWithFrame:CGRectMake(0,SCREEN_HEIGHT-20,SCREEN_WIDTH,20)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _allKeys.count;
}

- (LANPropertiesType)infoTypeAtIndexPath:(NSIndexPath *)indexPath {
    id key = _allKeys[indexPath.row];
    id value = _properties[key];
    if ([value isKindOfClass:NSDictionary.class]) {
        return LANPropertiesTypeDictionary;
    } else if ([value isKindOfClass:NSArray.class]) {
        return LANPropertiesTypeArray;
    } else if ([key isKindOfClass:NSDictionary.class]) {
        return LANPropertiesTypeKeyDict;
    } else {
        return LANPropertiesTypeValue;
    }
}

- (void)fetchInfoWithIndexPath:(NSIndexPath *)indexPath completionHandler:(LANItemInfoFetchBlock)block {
    id key = _allKeys[indexPath.row];
    LANPropertiesType type = [self infoTypeAtIndexPath:indexPath];
    if (type == LANPropertiesTypeValue) {
        block(UITableViewCellAccessoryNone, [key description], [_properties[key] description] ?: @"");
    } else {
        NSString *title;
        if (type == LANPropertiesTypeKeyDict) {
            title = [NSString stringWithFormat:@"Item %d", (int)indexPath.row];
        } else {
            title = [key description];
        }
        block(UITableViewCellAccessoryDisclosureIndicator, title, [NSString stringWithFormat:@"%d items", _properties ? [_properties[key] count] : [key count]]);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __block LANProListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        [self fetchInfoWithIndexPath:indexPath completionHandler:^(UITableViewCellAccessoryType accessoryType, NSString *title, NSString *subtitle) {
            if(accessoryType==UITableViewCellAccessoryDisclosureIndicator){
                cell = [[LANProListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellID"];
            } else{
                cell = [[LANProListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
            }
            cell.title = title;
            cell.subTitle = subtitle;
            cell.type = accessoryType;

        }];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id key = _allKeys[indexPath.row];
    if ([self infoTypeAtIndexPath:indexPath] != LANPropertiesTypeValue) {
        id info = _properties ? _properties[key] : key;
        LANProListViewController *infoController = [[LANProListViewController alloc] initWithProperties:info];
        [self fetchInfoWithIndexPath:indexPath completionHandler:^(UITableViewCellAccessoryType accessoryType, NSString *title, NSString *subtitle) {
            infoController.title = title;
            [infoController.pathDisplayView setDisplayPath:self.pathDisplayView.displayPath addPath:title];
        }];
        [self.navigationController pushViewController:infoController animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    return (action==@selector(copy:)||action==@selector(favoriteItem:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {

}





@end
