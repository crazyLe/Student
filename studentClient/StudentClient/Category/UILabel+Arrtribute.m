//
//  UILabel+Arrtribute.m
//  UILabelTest
//
//  Created by 周文艳 on 16/6/20.
//  Copyright © 2016年 jiuyi. All rights reserved.
//

#import "UILabel+Arrtribute.h"

@implementation UILabel (Arrtribute)

- (void)setEdgeToLeft:(CGFloat)edge WithString:(NSString *)text
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSUInteger length = [text length];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentLeft;//靠左显示
    style.firstLineHeadIndent = edge; // 距离左边 10
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    self.attributedText = attrString;
}

- (void)setEdgeToRight:(CGFloat)edge WithString:(NSString *)text
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    NSUInteger length = [text length];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentRight;//靠右显示
    style.tailIndent = - edge; //设置与尾部的距离
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, length)];
    self.attributedText = attrString;
}
@end
