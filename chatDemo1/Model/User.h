//
//  User.h
//  chatDemo1
//
//  Created by HeQichang on 15/8/3.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSNumber * uid;

@end
