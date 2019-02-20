//
//  XSVoiceRecManager.m
//  XSDemo
//
//  Created by admin on 2019/2/1.
//  Copyright © 2019 Sniper. All rights reserved.
//

#import "XSVoiceRecManager.h"
#import "IFlyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "XSParseRecResultHelper.h"

#define vrec [IFlySpeechRecognizer sharedInstance]
#define pcmRecorder [IFlyPcmRecorder sharedInstance]

@interface XSVoiceRecManager ()<IFlySpeechRecognizerDelegate, IFlyPcmRecorderDelegate>

@property(nonatomic, copy)void (^resultBlock)(NSString *resultStr);

@property(nonatomic, copy)NSString *theRecText;

@end

@implementation XSVoiceRecManager

+ (instancetype)shareVoiceRec {
    static dispatch_once_t onceToken;
    static XSVoiceRecManager *manager = nil;
    dispatch_once(&onceToken, ^{
        manager = [[XSVoiceRecManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupVoiceRec];
        [self setupKeyWords];
    }
    return self;
}

- (void)setupVoiceRec {
    
    [vrec cancel];
    
    [vrec setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    
    //set recognition domain
    [vrec setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    vrec.delegate = self;
    
    IATConfig *instance = [IATConfig sharedInstance];
    
    //set timeout of recording
    [vrec setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    //set VAD timeout of end of speech(EOS)
    [vrec setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
    //set VAD timeout of beginning of speech(BOS)
    [vrec setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
    //set network timeout
    [vrec setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    
    //set sample rate, 16K as a recommended option
    [vrec setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //set language
    [vrec setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
    //set accent
    [vrec setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
    
    //set whether or not to show punctuation in recognition results
    [vrec setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
    
    pcmRecorder.delegate = self;
    
    [pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
    
    [pcmRecorder setSaveAudioPath:nil];
}

- (void)startRecWithResultBlock:(void (^)(NSString * _Nonnull))resultBlock {
    self.theRecText = nil;
    self.resultBlock = resultBlock;
    
    [vrec cancel];
    
    //Set microphone as audio source
    [vrec setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //Set result type
    [vrec setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //Set the audio name of saved recording file while is generated in the local storage path of SDK,by default in library/cache.
    [vrec setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [vrec setDelegate:self];
    
    BOOL ret = [vrec startListening];
    NSLog(@"vrec start listening : %@", ret ? @"yes" : @"no");
}

- (void)stopRec {
    [vrec stopListening];
}

- (void)releaseRecResource {
    [vrec destroy];
}

#pragma mark - IFlySpeechRecognizerDelegate
- (void)onCompleted:(IFlySpeechError *)errorCode {
    NSLog(@"voice rec end with error : %@", errorCode.errorDesc);
    [vrec stopListening];
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast {
    NSLog(@"voice rec results : %@ and isLast: %@", results, isLast ? @"YES" : @"NO");
//    [vrec stopListening];
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    
    //    _result =[NSString stringWithFormat:@"%@%@", _textView.text,resultString];
    
    NSString * resultFromJson =  nil;
    
    if([IATConfig sharedInstance].isTranslate){
        
        NSDictionary *resultDic  = [NSJSONSerialization JSONObjectWithData:    //The result type must be utf8, otherwise an unknown error will happen.
                                    [resultString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        if(resultDic != nil){
            NSDictionary *trans_result = [resultDic objectForKey:@"trans_result"];
            
            if([[IATConfig sharedInstance].language isEqualToString:@"en_us"]){
                NSString *dst = [trans_result objectForKey:@"dst"];
                NSLog(@"dst=%@",dst);
                resultFromJson = [NSString stringWithFormat:@"%@\ndst:%@",resultString,dst];
            }
            else{
                NSString *src = [trans_result objectForKey:@"src"];
                NSLog(@"src=%@",src);
                resultFromJson = [NSString stringWithFormat:@"%@\nsrc:%@",resultString,src];
            }
        }
    }
    else{
        resultFromJson = [XSParseRecResultHelper stringFromJson:resultString];
    }
    
    if (self.theRecText) {
        self.theRecText = [NSString stringWithFormat:@"%@%@", self.theRecText, resultFromJson];
    } else {
        self.theRecText = resultFromJson;
    }
    
    if (isLast){
        
        if (self.resultBlock) {
            self.resultBlock(self.theRecText);
        }
//        [self.resultStringWithLastSign setString:@""];
    }
//    NSLog(@"resultFromJson=%@",resultFromJson);
    
}

// optional
/*!
 *  音量变化回调<br>
 *  在录音过程中，回调音频的音量。
 *
 *  @param volume -[out] 音量，范围从0-30
 */
- (void) onVolumeChanged: (int)volume {
    
}

/*!
 *  开始录音回调<br>
 *  当调用了`startListening`函数之后，如果没有发生错误则会回调此函数。<br>
 *  如果发生错误则回调onCompleted:函数
 */
- (void) onBeginOfSpeech {
    
}

/*!
 *  停止录音回调<br>
 *  当调用了`stopListening`函数或者引擎内部自动检测到断点，如果没有发生错误则回调此函数。<br>
 *  如果发生错误则回调onCompleted:函数
 */
- (void) onEndOfSpeech {
    //    [pcmRecorder stop];
}

/*!
 *  取消识别回调<br>
 *  当调用了`cancel`函数之后，会回调此函数，在调用了cancel函数和回调onCompleted之前会有一个<br>
 *  短暂时间，您可以在此函数中实现对这段时间的界面显示。
 */
- (void) onCancel {
    
}
#pragma mark - IFlyPcmRecorderDelegate


- (void)onIFlyRecorderBuffer:(const void *)buffer bufferSize:(int)size {
    NSLog(@"on onIFlyRecorderBuffer");
}

- (void)onIFlyRecorderError:(IFlyPcmRecorder *)recoder theError:(int)error {
    NSLog(@"on onIFlyRecorderError ");
}

- (void)onIFlyRecorderVolumeChanged:(int)power {
    //    NSLog(@"on ifly recorder volume changed %d", power);
}
#pragma mark - other
- (NSString *)recordPath {
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [arr firstObject];
    NSString *recordPath = [libPath stringByAppendingPathComponent:@"audioRecord.pcm"];
    return recordPath;
}

- (void)setupKeyWords {
    IFlyDataUploader *uploader = [[IFlyDataUploader alloc] init];
    //用户词表
#define USERWORDS   @"{\"userword\":[{\"name\":\"com.study.research.voiceRec.XSDemo\",\"words\":[\"T梁\",\"右腹板\",\"左腹板\",\"下缘\",\"马蹄\",\"横隔板\",\"横隔梁\",\"湿接缝\",\"铰缝\",\"支座\",\"墩盖梁\",\"台盖梁\",\"翼墙\",\"耳墙\",\"位置\",\"构件名称\",\"病害\",\"病害描述\"]}]}"
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS ];
    //设置上传参数
    [uploader setParameter:@"uup" forKey:@"sub"];
    [uploader setParameter:@"userword" forKey:@"dtt"];
    //启动上传（请注意name参数的不同）
    [uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error){
        //
        NSLog(@"grammerID : %@, error :%@", grammerID, error);
        NSLog(@"grammer error : %@", error.errorDesc);
    }name: @"userwords" data:[iFlyUserWords toString]];
}

@end
