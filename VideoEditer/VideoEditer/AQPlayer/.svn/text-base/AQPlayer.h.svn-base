//
//  AQPlayer.h
//
//  Created by leipeilin on 13-7-29.
//  Copyright (c) 2013年 infomedia. All rights reserved.
//

#ifndef __AQPLAYER_H__
#define __AQPLAYER_H__

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#include <vector>
using namespace std;

#define AAC_FRAME_SIZE              1024
#define kNumberAudioOutDataBuffers  100     //         
#define kAudioQueueBuffer           3       // 系统 Audio Queue 里的buffer个数
static const float gain_volume_out = 1.0;   // 音量 - 0~1.0

typedef struct AQParam
{
    int bits_per_sample;
    int clock_rate;
    int channel_count;
    int audio_float_format;     // 0 - int           1 - float
    int audio_packed_format;    // 0 - packet        1 - plane
    int audio_bigendium_format; // 0 - big endium    1 - little endium
}AQParam;



static void AQPlayCallback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer);



class AQPlayer 
{
public:
//    explicit AQPlayer(AQParam *aqPlayParam, audio_queue_play_cb aqPlayCb = aq_play_cb);
    AQPlayer();
    ~AQPlayer();
    
    // API function
    void AQPlayerInit(AQParam *aqPlayParam);                                                    // 初始化
    void AQPlayerUnInit();                                                                      // 反初始化
    void AQPlayerStartPlay();                                                                   // 开始播放声音
    void AQPlayerPausePlay();                                                                   // 暂停播放声音
    
    void Lock();
    void UnLock();
    
    vector<uint8_t *>   _playBufList;
    int                 _bufListReadIndex;
    
    int                 _playBufferByteSize;
    uint8_t             _curAvailableBufferCount;
    pthread_mutex_t     _mutex;
    
    bool                _started;
    AudioQueueRef       _playQueue;
    
private:
    void AQPlayerStopPlay();
    void InitAQ();
    void AQPlayerBufferInQueue();
    void AQPlayerAllocBuffer();
    
    int                 _rate;
    int                 _bits;
    int                 _channel;
    
    bool                _hasPlayed;
    
    int                 _floatFormat;
    int                 _packetFormat;
    int                 _bigEndium;
    
    
    
    CFStringRef         _uidname;
    AudioQueueBufferRef _playBuffers[kAudioQueueBuffer];
    AudioStreamBasicDescription _deviceFormat;
    AudioStreamBasicDescription _writeAudioFormat;
};


#endif  // __AQPLAYER_H__
