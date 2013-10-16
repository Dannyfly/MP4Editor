//
//  SerializationAction.h
//  VideoEditer
//
//  Created by liulu on 13-7-29.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CutVideoAction.h"
#import "AddAudioAction.h"
#import "MonochromeFilterAction.h"
#import "NegativeFilterAction.h"
#import "WatermarkFilterAction.h"
#include "action.h"

@interface SerializationAction : NSObject

+ (NSString*)serializationTimeToString:(VideoEditTime*)time;

+ (VideoEditTime*)serializationStringToTime:(NSString*)timeStr;

+(VideoEditTime*)serializationFloatToTime:(CGFloat)floatValue;

+ (BaseAction*)serializationActionWithItem:(ActionItem*)item;

+ (void)serializationDicWithVideoAction:(BaseAction*)action actionItemOutput:(ActionItem*)item;


@end
