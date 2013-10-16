//
//  BaseAction.h
//  VideoEditer
//
//  Created by liulu on 13-7-29.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoEditTime.h"

@interface BaseAction : NSObject

@property (strong, nonatomic) NSString* actionName;
@property (assign, nonatomic) int64_t beginTime;
@property (assign, nonatomic) int64_t endTime;

@end
