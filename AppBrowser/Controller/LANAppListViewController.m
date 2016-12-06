//
// Created by 蓝布鲁 on 2016/11/24.
// Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import "LANAppListViewController.h"
#import "LANAppHelper.h"
#import "LANAppListCell.h"
#import "LANAppViewController.h"
#import "NSArray+LAN.h"

@interface LANAppListViewController()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, retain)UISearchController *searchController;

@end

@implementation LANAppListViewController {
    NSArray *_installedAppArray;
    NSMutableArray *_list;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Installed App(0)";

    //setup view in controller
    [self setupView];

    //get data & refresh tableView
    [self refresh];
}

-(void)setupView{

    //init tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];

    //init searchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.tableView.tableHeaderView = self.searchController.searchBar;

    //init refreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [refreshControl addTarget:self
                       action:@selector(didRefreshControlValueChanged:)
             forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];


}

-(void)refresh{
    _installedAppArray = [[LANAppHelper allInstalledApplications] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *name1 = [LANAppHelper nameForApplication:obj1];
        NSString *name2 = [LANAppHelper nameForApplication:obj2];
        return [name1 compare:name2 options:NSCaseInsensitiveSearch];
    }];
    _list = [_installedAppArray mutableCopy];

    self.title = [NSString stringWithFormat:@"Installed App(%d)",_installedAppArray.count];

    [self.tableView reloadData];
}

- (void)didRefreshControlValueChanged:(UIRefreshControl *)sender {
    [self refresh];
    [sender performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.5];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LANAppListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell==nil){
        cell = [[LANAppListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        cell.application = _list[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    NSObject *application = _list[indexPath.row];

    LANAppViewController *appViewController = [[LANAppViewController alloc] init];
    appViewController.application = application;
    self.searchController.active = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Installed App" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:appViewController animated:true];

//    NSLog(@"class name:%@,properties:%@",NSStringFromClass([application class]),[NSArray getProperties:[application class]]);
//    NSLog(@"class name:%@,properties:%@",NSStringFromClass([application superclass]),[NSArray getProperties:[application superclass]]);
//    NSLog(@"class name:%@,properties:%@",NSStringFromClass([[application superclass] superclass]),[NSArray getProperties:[[application superclass] superclass]]);
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    _list = [[NSMutableArray alloc] init];
    NSString *searchText = searchController.searchBar.text.lowercaseString;
    if(searchText.length==0){
        _list = [_installedAppArray mutableCopy];
        [self.tableView reloadData];
    } else{
        for (id application in _installedAppArray) {
            NSString *appName = [LANAppHelper nameForApplication:application];
            if([appName.lowercaseString containsString:searchText]){
                [_list addObject:application];
            }
        }
        [self.tableView reloadData];
    }
}


@end
