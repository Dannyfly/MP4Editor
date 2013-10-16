//
//  PageScrollView.h
//  VideoEditer
//
//  Created by Clark on 13-8-22.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageScrollView : UIScrollView
{
    UIImageView* _selectedImgview;
}

@property (nonatomic, strong) NSMutableArray* viewArray;
@property (nonatomic, assign) int selectedIndex;

- (void)refreshScrollView;

- (void)refreshSubView;

@end
