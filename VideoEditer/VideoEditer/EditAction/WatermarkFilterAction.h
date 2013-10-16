//
//  WatermarkFilterAction.h
//  VideoEditer
//
//  Created by  mac on 13-9-6.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import "BaseFilterAction.h"

@interface WatermarkFilterAction : BaseFilterAction

@property (strong, nonatomic) NSString* imgPath;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;

@end
