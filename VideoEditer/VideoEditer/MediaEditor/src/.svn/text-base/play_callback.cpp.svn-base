//
//  EditCallback.cpp
//  VideoEditer
//
//  Created by leipeilin on 13-8-14.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#include "play_callback.h"
#include "media_editor_callback.h"


void PlayCallback::Open(void *delegate)
{
    _delegate = delegate;
}

void PlayCallback::PreviewTimeCallback(int64_t time)
{
    [(__bridge id<MediaEditorCallback>)_delegate PreviewTimeCallback:time];
}


void PlayCallback::ErrorCallback(FFPLAY_ERROR error)
{
}
