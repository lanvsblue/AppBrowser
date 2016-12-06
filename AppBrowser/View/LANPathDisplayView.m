//
//  LANPathDisplayView.m
//  AppBrowser
//
//  Created by 蓝布鲁 on 2016/11/30.
//  Copyright (c) 2016 lanvsblueCO. All rights reserved.
//

#import "LANPathDisplayView.h"

@interface LANPathDisplayView()

@property (nonatomic, retain)UILabel *pathLabel;
@end

@implementation LANPathDisplayView{
    NSMutableArray *_pathArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if(self=[super initWithFrame:frame]){
        [self initView];
        _pathArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)initView{
    self.backgroundColor = [UIColor grayColor];

    self.pathLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,0,self.width-5,self.height)];
    [self addSubview:self.pathLabel];
}

-(void)setupView {
    self.pathLabel.text = self.displayPath;
    self.pathLabel.font = [UIFont systemFontOfSize:12];
    self.pathLabel.textColor = [UIColor whiteColor];
    self.pathLabel.lineBreakMode = NSLineBreakByTruncatingHead;
}

- (void)setDisplayPath:(NSString *)displayPath {
    _pathArray = [[displayPath componentsSeparatedByString:@"."] mutableCopy];
}

- (NSString *)setDisplayPath:(NSString *)disPath addPath:(NSString *)addPath {
    self.displayPath = disPath;
    [self addPath:addPath];
    return self.displayPath;
}


-(NSString *)displayPath {
    return [_pathArray componentsJoinedByString:@"."];
}

- (NSString *)addPath:(NSString *)path {
    if([path hasPrefix:@"Item "]){
        _pathArray[_pathArray.count-1] = [NSString stringWithFormat:@"%@[%@]",_pathArray[_pathArray.count-1],[path substringFromIndex:5]];
    } else{
        [_pathArray addObject:path];
    }
    return self.displayPath;
}


@end
