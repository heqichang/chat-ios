//
//  QMDesignableUILabel.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/29.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "QMDesignableUILabel.h"

@implementation QMDesignableUILabel


//- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {2, 7, 2, 7};
//    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    if (!self.clipsToBounds) {
        self.clipsToBounds = YES;
    }
    self.layer.cornerRadius = cornerRadius;
}

@end
