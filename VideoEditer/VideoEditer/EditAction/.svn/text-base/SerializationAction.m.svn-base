//
//  SerializationAction.m
//  VideoEditer
//
//  Created by liulu on 13-7-29.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "SerializationAction.h"

@implementation SerializationAction

+ (NSString*)serializationTimeToString:(VideoEditTime*)time
{
    @autoreleasepool {
        //传入时间格式未定
        //输出时间格式使用字符串类型，格式：00:00:10.123
        NSString* hh = @"";
        if (time.hh<10) {
            hh = [NSString stringWithFormat:@"0%d",time.hh];
        } else {
            hh = [NSString stringWithFormat:@"%d",time.hh];
        }
        
        NSString* mm = @"";
        if (time.mm<10) {
            mm = [NSString stringWithFormat:@"0%d",time.mm];
        } else {
            mm = [NSString stringWithFormat:@"%d",time.mm];
        }
        
        NSString* ss = @"";
        if (time.ss<10) {
            ss = [NSString stringWithFormat:@"0%.3f",time.ss];
        } else {
            ss = [NSString stringWithFormat:@"%.3f",time.ss];
        }
        
        NSString* timeStr = [NSString stringWithFormat:@"%@:%@:%@",hh,mm,ss];
        return timeStr;
    }
}

+ (VideoEditTime*)serializationStringToTime:(NSString*)timeStr
{
    @autoreleasepool {
        //传入时间格式未定
        //输出时间格式使用字符串类型，格式：00:00:10.123
        VideoEditTime* time = [[VideoEditTime alloc] init];
        NSRange range1 = [timeStr rangeOfString:@":"];
        if (range1.location != NSNotFound) {
            time.hh = [[timeStr substringToIndex:range1.location] intValue];
            timeStr = [timeStr stringByReplacingCharactersInRange:NSMakeRange(0, range1.location+1) withString:@""];
        }
        NSRange range2 = [timeStr rangeOfString:@":"];
        if (range2.location != NSNotFound) {
            time.mm = [[timeStr substringToIndex:range2.location] intValue];
            timeStr = [timeStr stringByReplacingCharactersInRange:NSMakeRange(0, range2.location+1) withString:@""];
        }
        time.ss = [timeStr floatValue];
        return time;
    }
    
}

+(VideoEditTime*)serializationFloatToTime:(CGFloat)floatValue
{
    @autoreleasepool {
        VideoEditTime* time = [[VideoEditTime alloc] init];
        time.ss = fmodf(floatValue, 60.0);
        time.mm = fmodf(floatValue/60, 60.0);
        time.hh = floatValue/60/60;
        return time;
    }
}

+ (BaseAction*)serializationActionWithItem:(ActionItem*)item
{
#define GET_PARAM_STR(x) [NSString stringWithCString:item->_param[x].asString().c_str() encoding:NSUTF8StringEncoding];
#define GET_PARAM_INT(x) item->_param[x].asInt64()
    NSString* name = GET_PARAM_STR("Name");
    int64_t beginTime = GET_PARAM_INT("BeginTime");
    int64_t endTime = GET_PARAM_INT("EndTime");
    if ([name isEqualToString:@"CutVideoAction"]) {
        //裁剪视频
        CutVideoAction* action = [[CutVideoAction alloc] init];
        action.actionName = name;
        action.beginTime = beginTime;
        action.endTime = endTime;
        return action;
    } else if ([name isEqualToString:@"AddAudioAction"]) {
        //添加音频
        AddAudioAction* action = [[AddAudioAction alloc] init];
        action.actionName = name;
        action.beginTime = beginTime;
        action.endTime = endTime;
        action.audioFilePath = GET_PARAM_STR("FilePath");
        action.audioBeginTime = GET_PARAM_INT("AudioBeginTime");
        action.audioEndTime = GET_PARAM_INT("AudioEndTime");
        action.volumeRate = item->_param["VolumeRate"].asFloat();
        return action;
    } else if ([name isEqualToString:@"MonochromeFilterAction"]) {
        //黑白滤镜
        MonochromeFilterAction* action = [[MonochromeFilterAction alloc] init];
        action.actionName = name;
        action.beginTime = beginTime;
        action.endTime = endTime;
        return action;
    } else if ([name isEqualToString:@"NegativeFilterAction"]) {
        //反色滤镜
        NegativeFilterAction* action = [[NegativeFilterAction alloc] init];
        action.actionName = name;
        action.beginTime = beginTime;
        action.endTime = endTime;
        return action;
    } else if ([name isEqualToString:@"WatermarkFilterAction"]) {
        //水印滤镜
        WatermarkFilterAction* action = [[WatermarkFilterAction alloc] init];
        action.actionName = name;
        action.beginTime = beginTime;
        action.endTime = endTime;
        action.imgPath = GET_PARAM_STR("ImgPath");
        return action;
    }
    return nil;
}

+ (void)serializationDicWithVideoAction:(BaseAction*)action actionItemOutput:(ActionItem*)item
{
    item->_param.empty();
    item->_param["Name"] = [action.actionName UTF8String];
    item->_param["BeginTime"] = action.beginTime;
    item->_param["EndTime"] = action.endTime;
    
    if ([action isKindOfClass:[BaseFilterAction class]]) {
    }
    if ([action isKindOfClass:[CutVideoAction class]]) {
        //裁剪视频
    } else if([action isKindOfClass:[AddAudioAction class]]) {
        //添加音频
        AddAudioAction* addAudioAction = (AddAudioAction*)action;
        
        item->_param["FilePath"] = [addAudioAction.audioFilePath UTF8String];
        item->_param["AudioBeginTime"] = addAudioAction.audioBeginTime;
        item->_param["AudioEndTime"] = addAudioAction.audioEndTime;
        item->_param["VolumeRate"] = addAudioAction.volumeRate;
    } else if([action isKindOfClass:[MonochromeFilterAction class]]) {
        //黑白滤镜
    } else if([action isKindOfClass:[NegativeFilterAction class]]) {
        //反色滤镜
    } else if([action isKindOfClass:[WatermarkFilterAction class]]) {
        //水印滤镜
        WatermarkFilterAction* watermarkFilterAction = (WatermarkFilterAction*)action;
         item->_param["ImgPath"] = [watermarkFilterAction.imgPath UTF8String];
    }
}

@end
