//
//  QMDesignableUIButton.m
//  chatDemo1
//
//  Created by HeQichang on 15/7/17.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import "QMDesignableUIButton.h"

@implementation QMDesignableUIButton

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = [borderColor CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}


@end
