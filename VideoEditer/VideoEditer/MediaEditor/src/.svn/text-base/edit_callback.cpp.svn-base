//
//  EditCallback.cpp
//  VideoEditer
//
//  Created by leipeilin on 13-8-14.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#include "edit_callback.h"
#include "media_editor_callback.h"

void EditCallback::Open(void *delegate)
{
    _delegate = delegate;
}

void EditCallback::ProgressCallback(int percentage)
{
    [(__bridge id<MediaEditorCallback>)_delegate SaveProgressCallback:percentage :_type];
}

void EditCallback::setType(int type)
{
    _type = type;
}

int EditCallback::getType()
{
    return _type;
}


