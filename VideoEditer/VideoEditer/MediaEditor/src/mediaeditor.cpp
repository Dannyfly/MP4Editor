#include <fstream>
#include "lm_time.h"
#include "mediaeditor.h"
#include "image_utils.h"
#import "VEVideoPlayingView.h"


MediaEditor::MediaEditor()
{
    _media = NULL;
    _thumMedia = NULL;
    _thumbBuf = NULL;
    _yuvBuf = NULL;
}

MediaEditor::~MediaEditor()
{
    Close();
}

int MediaEditor::Open(const char *srcPath, void* pview)
{
    int ret;
    
    Close();
    
    _startTime = 0;
    _endTime = 0;
    _curTime = 0;
    
    _videoView = pview;
    _delegate = (__bridge id<MediaEditorCallback>)pview;
    
	_media = new MP4File();
    if (!_media)
        return -1;
    
    ret = _media->Open(srcPath);
    if (ret != 0)
    {
        return -1;
    }
    
    _thumMedia = new MP4File();
    if (!_thumMedia)
        return -1;
    
    _media->GetFormat(&_format);
    
    _thumbBufSize = _format.video_width * _format.video_height * 3;
    _thumbBuf = new uint8_t[_thumbBufSize];
    if (NULL == _thumbBuf)
        return -1;
    
    _yuvBufSize = _thumbBufSize / 2;
    _yuvBuf = new uint8_t[_yuvBufSize];
    if (!_yuvBuf)
        return -1;
    
    _progressCb.Open((__bridge void *)_delegate);
    _playCb.Open((__bridge void *)_delegate);
    
    _openglView.opengl_set_view((__bridge void *)(((__bridge VEVideoPlayingView *)_videoView).openglView));
    _vidfilter.Open(&_format, &_openglView);
    _audfilter.Open(&_format);
    
    _player.Open(_format, &_vidfilter, &_audfilter);
    _ffplay.Open(srcPath, &_player, &_playCb);
    
    return 0;
}

void MediaEditor::Close()
{
	if(NULL != _media)
	{
		delete _media;
		_media = NULL;
	}
    if (NULL != _thumMedia)
    {
        delete _thumMedia;
        _thumMedia = NULL;
    }
    if (NULL != _thumbBuf)
    {
        delete _thumbBuf;
        _thumbBuf = NULL;
    }
    if (NULL != _yuvBuf)
    {
        delete _yuvBuf;
        _yuvBuf = NULL;
    }
}

void MediaEditor::SetPeriod(int64_t startTime, int64_t endTime)
{
    _startTime = startTime;
    _endTime = endTime;
    _ffplay.SetStartAndEndTime(startTime, endTime);
}

void MediaEditor::SetCurTime(int64_t curTime)
{
    _curTime = curTime;
    FFPLAY_STATE state = GetPlayState();
    if (state != FFPLAY_STATE_STOPED)
        Seek(curTime);
}

void MediaEditor::SetTempDir(const char *destDir)
{
    string thumFile = destDir;
    
    thumFile += "/thumb.mp4";
    _thumMedia->Open(thumFile.c_str());
    
    std::ifstream input(_media->GetFileName(), ios::binary);
    std::ofstream output(thumFile.c_str(),ios::binary);
    output << input.rdbuf();
    
    _media->SetTempDirectory(destDir);
    _thumMedia->SetTempDirectory(destDir);
}

void MediaEditor::AddVideoAction(Json::Value &action)
{
    ActionItem action1(action["Name"].asString().c_str(), action["BeginTime"].asString().c_str(), action["EndTime"].asString().c_str(), action);
    _vidfilter.Add(action1);
    
}

void MediaEditor::AddAudioAction(Json::Value &action)
{
    ActionItem action1(action["Name"].asString().c_str(), action["BeginTime"].asString().c_str(), action["EndTime"].asString().c_str(), action);
    _audfilter.Add(action1);
}

int MediaEditor::GetVideoActionNum()
{
    return _vidfilter.GetActionNum();
}

int MediaEditor::GetAudioActionNum()
{
    return _audfilter.GetActionNum();
}

ActionItem& MediaEditor::GetVideoActionItemById(int id)
{
    return _vidfilter.GetActionItemById(id);
}

ActionItem& MediaEditor::GetAudioActionItemById(int id)
{
    return _audfilter.GetActionItemById(id);
}

void MediaEditor::EditVideoAction(ActionItem &action, int id)
{
    _vidfilter.Edit(action, id);
}

void MediaEditor::EditAudioAction(ActionItem &action, int id)
{
    _audfilter.Edit(action, id);
}

void MediaEditor::RemoveVideoAction(int id)
{
    _vidfilter.Remove(id);
}

void MediaEditor::RemoveAudioAction(int id)
{
    _audfilter.Remove(id);
}

void MediaEditor::EmptyVideoAction()
{
    _vidfilter.Empty();
}

void MediaEditor::EmptyAudioAction()
{
    _audfilter.Empty();
}

void MediaEditor::StartPlayer()
{
    FFPLAY_STATE state = _ffplay.GetPlayState();
    if (state == FFPLAY_STATE_STOPED)
        _audfilter.Stop();
    _ffplay.Start(_curTime, _startTime, _endTime);
    _curTime = _startTime;
}

void MediaEditor::PausePlayer()
{
    _ffplay.Pause();
}

void MediaEditor::ResumePlayer()
{
    _ffplay.Resume();
}

void MediaEditor::ClosePlayer()
{
    _ffplay.Close();
}

FFPLAY_STATE MediaEditor::GetPlayState()
{
    return _ffplay.GetPlayState();
}

int64_t MediaEditor::GetCurrentPlayTime()
{
    return _ffplay.GetCurrentPlayTime();
}

void MediaEditor::Seek(int64_t us)
{
    _ffplay.Seek(us);
}

void MediaEditor::Cut(const char *destPath)
{
    ClosePlayer();
    
    param.empty();
    param["cmd"] = "cut";
    param["destpath"] = destPath;
    pthread_create(&_process_tid, NULL, EditProcessThread, this);
}

void MediaEditor::Merge(const char *secondPath, const char *destPath)
{
    ClosePlayer();
    
    param.empty();
    param["cmd"] = "merge";
    param["secondpath"] = secondPath;
    param["destpath"] = destPath;
    pthread_create(&_process_tid, NULL, EditProcessThread, this);
}

void MediaEditor::Save2File(const char *destPath)
{
    ClosePlayer();
    
    param["cmd"] = "save";
	param["file"] = destPath;
    pthread_create(&_process_tid, NULL, EditProcessThread, this);
}

void MediaEditor::cut(int64_t startTime, int64_t dualTime, MediaFile* destMp4File)
{
    _media->SetEditCallBack(&_progressCb);
    _progressCb.setType(1);
    _media->Cut(startTime, dualTime, destMp4File);
}

void MediaEditor::merge(MediaFile* secondFile, MediaFile* destFile)
{
    _media->Merge(secondFile, destFile);
}

void MediaEditor::save(int64_t startTime, int64_t dualTime, MediaFile* destMp4File)
{
    if (_audfilter.GetActionNum() == 0 && _vidfilter.GetActionNum() == 0)
    {
        _progressCb.setType(3);
        _thumMedia->SetEditCallBack(&_progressCb);
        _thumMedia->Cut(startTime, dualTime, destMp4File);
    }
    else
    {
        _thumMedia->SetEditCallBack(NULL);
        _thumMedia->Cut(startTime, dualTime, NULL);
        _audfilter.Close();
        _vidfilter.SetOffsetTime(startTime);
        _audfilter.SetOffsetTime(startTime);
        if (_vidfilter.GetActionNum() == 0)
            _thumMedia->SetFilters(NULL, &_audfilter);
        else if (_audfilter.GetActionNum() == 0)
            _thumMedia->SetFilters(&_vidfilter, NULL);
        else
            _thumMedia->SetFilters(&_vidfilter, &_audfilter);
        _progressCb.setType(3);
        _thumMedia->SetEditCallBack(&_progressCb);
        _thumMedia->Transfer(destMp4File);
    }
}


void MediaEditor::EditProcess()
{
    if (param["cmd"].asString().compare("cut") == 0)
    {
        int64_t dualTime = _endTime - _startTime;
        string destPath = param["destpath"].asString();
        if (!destPath.compare(""))
        {
            cut(_startTime, dualTime, NULL);
        }
        else
        {
            MP4File destFile;
            destFile.Open(destPath.c_str());
            cut(_startTime, dualTime, &destFile);
        }
    }
    else if (param["cmd"].asString().compare("merge") == 0)
    {
        string secondPath = param["secondpath"].asString();
        string destPath = param["destpath"].asString();
        
        MP4File secondFile;
        secondFile.Open(secondPath.c_str());
        
        if (destPath.compare(""))
        {
            MP4File destFile;
            destFile.Open(destPath.c_str());
            merge(&secondFile, &destFile);
        }
        else
        {
            merge(&secondFile, NULL);
        }
    }
    else if (param["cmd"].asString().compare("save") == 0)
    {
        string destPath = param["file"].asString();
        MP4File destFile;
        destFile.Open(destPath.c_str());
        save(_startTime, _endTime-_startTime, &destFile);
    }
}


void *MediaEditor::EditProcessThread(void *arg)
{
    MediaEditor *_self = (MediaEditor *)arg;
	_self->EditProcess();
    return NULL;
}

int MediaEditor::GetFormat(MediaFormat &mf)
{
	//copy media format information
	mf._width 				 = _format.video_width;
	mf._height 				 = _format.video_height;
	mf._totaltime 			 = _format.during_time;
	mf._video_avg_frame_rate = _format.video_avg_frame_rate;
	mf._audio_sample_rate 	 = _format.audio_sample_rate;
	mf._audio_channels 		 = _format.audio_channels;
	mf._audio_bits_per_sample = _format.audio_bits_per_sample;
    
	return 0;
}

int MediaEditor::GetThumbnail( char *pbuf, int buflen, int64_t time, int width, int height)
{
    return _thumMedia->GetThumbnail((uint8_t *)pbuf, buflen, time, width, height);
}

ThunbImgWithBuffer* MediaEditor::GetThumbnailImage(int64_t timePos, ThunbImgWithBuffer* imgWithBuffer)
{
    imgWithBuffer.buffer = new uint8_t[_thumbBufSize];
    _thumMedia->GetThumbnail((uint8_t *)_yuvBuf, _yuvBufSize, timePos, _format.video_width, _format.video_height);
    ConvertYV12ToRGB24(_yuvBuf, imgWithBuffer.buffer, _format.video_width, _format.video_height);
    
    // 创建工程时选择了ARC则不能设置自动释放缓冲池
    //    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgWithBuffer.buffer, _thumbBufSize, NULL);
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceRGB();
    CGImageRef ir = CGImageCreate(_format.video_width, _format.video_height,
                                  8, 24, _format.video_width*3, cs,
                                  kCGImageAlphaNoneSkipFirst, provider,
                                  NULL, NO, kCGRenderingIntentDefault);
    CGColorSpaceRelease(cs);
    CGDataProviderRelease(provider);
    imgWithBuffer.image = [[UIImage alloc] initWithCGImage:ir scale:1.0 orientation:UIImageOrientationUp];
    CGImageRelease(ir);
    
    return imgWithBuffer;
    
    //    [pool drain];
    
}

