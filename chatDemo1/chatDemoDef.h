//
//  chatDemoDef.h
//  chatDemo1
//
//  Created by HeQichang on 15/7/31.
//  Copyright (c) 2015年 heqichang. All rights reserved.
//

#ifndef chatDemo1_chatDemoDef_h
#define chatDemo1_chatDemoDef_h

#define HEXRGBCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define KKEYCHAIN_SERVICE_NAME @"QMService"

#endif
