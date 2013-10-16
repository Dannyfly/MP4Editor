//
//  EditCallback.h
//  VideoEditer
//
//  Created by leipeilin on 13-8-14.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#ifndef __PLAY_CALLBACK_H__
#define __PLAY_CALLBACK_H__

#include "play_callback_base.h"

class PlayCallback : public PlayCallbackBase
{
public:
    PlayCallback() : _delegate(NULL){};
    virtual ~PlayCallback() {};

public:
    void Open(void *delegate);
    virtual void PreviewTimeCallback(int64_t time);
    virtual void ErrorCallback(FFPLAY_ERROR error);
    
private:
    void *_delegate;
};

#endif //__PLAY_CALLBACK_H__
