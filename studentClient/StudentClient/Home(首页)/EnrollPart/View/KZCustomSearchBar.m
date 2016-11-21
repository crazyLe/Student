//
//  KZCustomSearchBar.m
//  StudentClient
//
//  Created by sky on 2016/9/27.
//  Copyright © 2016年 Anhui Shengshi Kangzhuang Network Technology Development Co., Ltd. All rights reserved.
//

#import "KZCustomSearchBar.h"

@implementation KZCustomSearchBar
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //设置背景图是为了去掉上下黑线
        self.backgroundImage = [UIImage new];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UITextField *searchField;

    for (int i = 0; i < self.subviews.count; i++) {
        UIView *view = self.subviews[i];

        for (int j = 0; j < view.subviews.count; j++) {
            if ([view.subviews[j] isKindOfClass:[UITextField class]]) {
                searchField = (UITextField *) view.subviews[j];
                break;
            }
        }
    }

    if (searchField) {
        [searchField setValue:[UIColor colorWithHexString:@"#A3A3A3"] forKeyPath:@"_placeholderLabel.textColor"];
        [searchField setTextColor:[UIColor colorWithHexString:@"#333333"]];
        [searchField setBackgroundColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.7]];
        [searchField setFont:[UIFont systemFontOfSize:12]];
        searchField.layer.masksToBounds = YES;
        searchField.layer.cornerRadius = CGRectGetHeight(searchField.bounds) / 2;
    }
}

@end
