//
//  ThunbImgWithBuffer.h
//  VideoEditer
//
//  Created by leipeilin on 13-8-6.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThunbImgWithBuffer : NSObject

@property (strong, nonatomic) UIImage* image;
@property (assign, nonatomic) uint8_t* buffer;

@end
