//
//  LANAppViewController.m
//  AppBrowser
//
//  Created by 蓝布鲁 on 2016/11/29.
//  Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import "LANAppViewController.h"
#import "LANAppHelper.h"
#import "LANProListViewController.h"
#import "LANPathDisplayView.h"
#import "LANProListCell.h"

@interface LANAppViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation LANAppViewController{
    NSDictionary *_infoDictionary;
    NSArray *_allKeys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [LANAppHelper nameForApplication:self.application];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupView];

    //refresh
    [self refresh];


}



- (void)setupView {

    //setup navigation item
    [self setupNavigation];

    //setup header view
    [self setupHeaderView];

    //setup property tableView
    [self setupTableView];

}

-(void)setupNavigation{
    UIBarButtonItem *removeItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                target:self
                                                                                action:@selector(removeApp)];

    UIBarButtonItem *openItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                              target:self
                                                                              action:@selector(openApp)];
    self.navigationItem.rightBarButtonItems = @[removeItem, openItem];
}

-(void)setupHeaderView{
    //header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,64,SCREEN_WIDTH,150)];
    headerView.layer.borderWidth = 0.2;
    headerView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0,0,headerView.width,headerView.height);
    [headerView addSubview:effectView];

    [self.view addSubview:headerView];

    //image of application
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,15,headerView.height-30,headerView.height-30)];
    imageView.image = [LANAppHelper iconForApplication:self.application];
    [headerView addSubview:imageView];

    //app name
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.rightX+15,imageView.originY,0,0)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.text = [LANAppHelper nameForApplication:self.application];
    [nameLabel sizeToFit];
    [headerView addSubview:nameLabel];

    //vendor name
    UILabel *vendorLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.rightX+15,nameLabel.bottomY+5,0,0)];
    vendorLabel.text = [LANAppHelper vendorNameForApplication:self.application]?[LANAppHelper vendorNameForApplication:self.application]:@" ";
    vendorLabel.font = [UIFont systemFontOfSize:12];
    vendorLabel.textColor = [UIColor grayColor];
    vendorLabel.numberOfLines = 0;
    [vendorLabel sizeToFit];
    [headerView addSubview:vendorLabel];

    //bundle identifier
    UILabel *bundleLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.rightX+15,vendorLabel.bottomY+5,0,0)];
    bundleLabel.text = [LANAppHelper bundleIDForApplication:self.application];
    bundleLabel.font = [UIFont systemFontOfSize:12];
    bundleLabel.textColor = [UIColor grayColor];
    [bundleLabel sizeToFit];
    [headerView addSubview:bundleLabel];

    //properties
    UIButton *propertiesButton = [UIButton buttonWithType:UIButtonTypeSystem];
    propertiesButton.frame = CGRectMake(headerView.rightX-60-15,imageView.bottomY-30,60,30);
    [propertiesButton setTitle:@"INFO" forState:UIControlStateNormal];
    [propertiesButton setTitleColor:[UIColor colorWithRed:0.08 green:0.49 blue:0.98 alpha:1.00] forState:UIControlStateNormal];
    propertiesButton.layer.masksToBounds = true;
    propertiesButton.layer.cornerRadius = 3;
    propertiesButton.layer.borderColor = [UIColor colorWithRed:0.08 green:0.49 blue:0.98 alpha:1.00].CGColor;
    propertiesButton.layer.borderWidth = 1;
    propertiesButton.layer.shadowOffset = CGSizeZero;
    [propertiesButton addTarget:self action:@selector(propertiesButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:propertiesButton];
}

-(void)setupTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,150+64,SCREEN_WIDTH,self.view.height-150-64)
                                                  style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource  = self;
    [self.view addSubview:self.tableView];
}

-(void)refresh{
    //get info.plist
    _infoDictionary = [self.application valueForKeyPath:APP_PROPERTY_LIST_KEY_PATH];
    _allKeys = [_infoDictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if([obj1 isKindOfClass:[NSString class]]){
            return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
        } else if ([obj1 isKindOfClass:[NSNumber class]]){
            return [obj1 compare:obj2];
        }
        return NSOrderedSame;
    }];
}

- (LANPropertiesType)infoTypeAtIndexPath:(NSIndexPath *)indexPath {
    id key = _allKeys[indexPath.row];
    id value = _infoDictionary[key];
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
        block(UITableViewCellAccessoryNone, [key description], [_infoDictionary[key] description] ?: @"");
    } else {
        NSString *title;
        if (type == LANPropertiesTypeKeyDict) {
            title = [NSString stringWithFormat:@"Item %d", (int)indexPath.row];
        } else {
            title = [key description];
        }
        block(UITableViewCellAccessoryDisclosureIndicator, title, [NSString stringWithFormat:@"%d items", _infoDictionary ? [_infoDictionary[key] count] : [key count]]);
    }
}

- (void)removeApp {
    //if it is simulator , can be uninstall

#if TARGET_OS_SIMULATOR
    [LANAppHelper removeApplication:self.application];
    [self.navigationController popViewControllerAnimated:true];
#elif TARGET_OS_IPHONE


    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Uninstall failed"
                                                                   message:@"It only can be used on simulator"
                                                            preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *done = [UIAlertAction actionWithTitle:@"Done"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {

                                                 }];
    [alert addAction:done];
#endif

}

- (void)openApp {
    [LANAppHelper openApplication:self.application];
}

-(void)propertiesButtonTapped{
    LANProListViewController *controller = [[LANProListViewController alloc]
            initWithProperties:[LANAppHelper infoForApplication:self.application]];
    controller.pathDisplayView.displayPath = @"LSApplicationProxy";
    controller.title = @"LSApplicationProxy";
    [self.navigationController pushViewController:controller animated:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infoDictionary.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,20,200,20)];
    headerLabel.text = @"info.plist";
    headerLabel.font = [UIFont systemFontOfSize:15];
    headerLabel.textColor = [UIColor grayColor];
    [header addSubview:headerLabel];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
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
        id info = _infoDictionary;
        LANProListViewController *infoController = [[LANProListViewController alloc] initWithProperties:info];
        [self fetchInfoWithIndexPath:indexPath completionHandler:^(UITableViewCellAccessoryType accessoryType, NSString *title, NSString *subtitle) {
            infoController.title = title;
            [infoController.pathDisplayView setDisplayPath:@"_infoDictionary.propertyList" addPath:title];
        }];
        [self.navigationController pushViewController:infoController animated:YES];
    }
}


@end
