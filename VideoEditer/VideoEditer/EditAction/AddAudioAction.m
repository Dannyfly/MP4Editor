//
//  AddAudioAction.m
//  VideoEditer
//
//  Created by liulu on 13-7-29.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "AddAudioAction.h"

@implementation AddAudioAction

- (id)init
{
    self = [super init];
    if (self) {
        self.actionName = @"AddAudioAction";
        self.audioFilePath = @"";
        self.audioBeginTime = 0;
        self.audioEndTime = 0;
        self.volumeRate = 0;
    }
    return self;
}

@end
