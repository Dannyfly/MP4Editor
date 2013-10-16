//
//  MediaEditorCallback.h
//  VideoEditer
//
//  Created by leipeilin on 13-8-14.
//  Copyright (c) 2013年 liulu. All rights reserved.
//

#ifndef VideoEditer_MediaEditorCallback_h
#define VideoEditer_MediaEditorCallback_h

#ifdef ANDORID
class MediaEditorCallback
{
public:
    MediaEditorCallback() {};
    virtual ~MediaEditorCallback() {};
    
    // 显示当前播放的时间
    virtual void PreviewTimeCallback(int64_t curTime) = 0;
    
    // 显示当前的保存进度(cut/merge/savefile)
    virtual void SaveProgressCallback(int percentage, int type) = 0;
    
};
#else
@protocol MediaEditorCallback <NSObject>

-(void)PreviewTimeCallback:(int64_t) curTime;

-(void)SaveProgressCallback:(int)percentage: (int)type;

@end
#endif // ANDROID

#endif
