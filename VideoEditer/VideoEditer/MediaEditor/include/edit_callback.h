//
//  EditCallback.h
//  VideoEditer
//
//  Created by leipeilin on 13-8-14.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#ifndef __EDIT_CALLBACK_H__
#define __EDIT_CALLBACK_H__

#include "edit_callback_base.h"

class EditCallback : public EditCallbackBase
{
public:
    EditCallback() : _delegate(NULL), _type(-1) {};
    virtual ~EditCallback() {};
    
public:
    void Open(void *delegate);
    virtual void ProgressCallback(int percentage);
    void setType(int type);
    int getType();
    
private:
    void *_delegate;
    int _type;       // 1 - cut   2 - merge   3 - save
};

#endif //__EDIT_CALLBACK_H__
