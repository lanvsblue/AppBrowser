//
// Created by 蓝布鲁 on 2016/11/24.
// Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import "LANAppListCell.h"
#import "LANAppHelper.h"


@implementation LANAppListCell {

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.image = [LANAppHelper iconForApplication:self.application];
    self.textLabel.text = [LANAppHelper nameForApplication:self.application];

}
@end