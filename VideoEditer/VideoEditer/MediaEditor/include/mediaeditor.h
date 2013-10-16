#ifndef _MEDIA_EDITOR_H_
#define _MEDIA_EDITOR_H_

#include <pthread.h>
#include "action.h"
#include "mediaeditor.h"
#include "mp4_file.h"
#include "video_filter.h"
#include "audio_filter.h"
#include "AQPlayer.h"
#include "ThunbImgWithBuffer.h"
#include "SerializationAction.h"
#include "edit_callback.h"
#include "play_callback.h"
#include "media_editor_callback.h"
#include "ios_opengl_view.h"
#include "ios_player.h"
#include "ffplay.h"

class MediaFormat
{
public:
	MediaFormat():
    _width(0),
    _height(0),
    _totaltime(0),
    _video_avg_frame_rate(0.0f),
    _audio_sample_rate(0),
    _audio_channels(0),
    _audio_bits_per_sample(0) {};
    ~MediaFormat() {};
    
	int  	_width;                 /////// For Video ///////
	int     _height;
	int64_t	_totaltime;
	float 	_video_avg_frame_rate;
	int 	_audio_sample_rate;     /////// For Audio ///////
	int 	_audio_channels;
	int     _audio_bits_per_sample;
};


class MediaEditor
{
public:
	MediaEditor();
	virtual ~MediaEditor();
public:
    int Open(const char *srcPath, void* pview);
    void Close();
    
    void SetPeriod(int64_t startTime, int64_t endTime);
    void SetCurTime(int64_t curTime);
    void SetTempDir(const char *destDir);
    void AddVideoAction(Json::Value &action);
    void AddAudioAction(Json::Value &action);
    
    
    void StartPlayer();
    void PausePlayer();
    void ResumePlayer();
    void ClosePlayer();
    void Seek(int64_t us);
    FFPLAY_STATE GetPlayState();
    int64_t GetCurrentPlayTime();
    
    
    int GetFormat(MediaFormat &mf);
    int GetThumbnail( char *pbuf, int buflen, int64_t time, int width, int height);
    ThunbImgWithBuffer* GetThumbnailImage(int64_t timePos, ThunbImgWithBuffer* imgWithBuffer);
    
    void Cut(const char *destPath);
    void Merge(const char *secondPath, const char *destPath);
    void Save2File(const char *destPath);
public:
    int GetVideoActionNum();
    int GetAudioActionNum();
    ActionItem& GetVideoActionItemById(int id);
    ActionItem& GetAudioActionItemById(int id);
    void EditVideoAction(ActionItem &action, int id);
    void EditAudioAction(ActionItem &action, int id);
    void RemoveVideoAction(int id);
    void RemoveAudioAction(int id);
    void EmptyVideoAction();
    void EmptyAudioAction();
private:
    void cut(int64_t startTime, int64_t dualTime, MediaFile* destMp4File);
    void merge(MediaFile* secondFile, MediaFile* destFile);
    void save(int64_t startTime, int64_t endTime, MediaFile* destMp4File);
    void EditProcess();
private:
    static void *EditProcessThread(void *arg);
    pthread_t _process_tid;
    Json::Value param;
private:
    int64_t _startTime;
    int64_t _endTime;
    int64_t _curTime;
    
    MediaFileFormat _format;
    IOSOpenglView   _openglView;
    IOSPlayer _player;
    FFPlay _ffplay;
    
    MediaFile *_media;
    MediaFile *_thumMedia;
    
    EditCallback _progressCb;
    PlayCallback _playCb;
private:
    int         _thumbBufSize;
    uint8_t     *_thumbBuf;
    int         _yuvBufSize;
    uint8_t     *_yuvBuf;
public:
    VideoFilter _vidfilter;
	AudioFilter _audfilter;
    void *_videoView;
    id<MediaEditorCallback> _delegate;
};


#endif //_MEDIA_EDITOR_H_
