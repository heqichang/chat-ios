//
//  QMDesignableUILabel.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/29.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface QMDesignableUILabel : UILabel

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic) IBInspectable CGFloat leftAndRightInsetPoint;

@end
