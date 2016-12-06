//
//  LANProListCell.m
//  AppBrowser
//
//  Created by 蓝布鲁 on 2016/11/30.
//  Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import "LANProListCell.h"
#import "NSDictionary+LAN.h"

@implementation LANProListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

-(void)initView{

}

-(void)layoutSubviews {
    [super layoutSubviews];
    if([self.title isEqualToString:SUPER_CLASS]){
        self.textLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    self.textLabel.text = self.title;
    self.detailTextLabel.text = self.subTitle;
    self.accessoryType = self.type;
}

- (void)copy:(id)sender {
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@ | %@",self.title,self.subTitle];
}

//-(void)favoriteItem:(id)sender{
//    NSLog(@"favoriteItem");
//}
//

@end
