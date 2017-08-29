//
//  SoundPlayer.m
//  语音播报
//
//  Created by sfm on 16/6/18.
//  Copyright © 2016年 sfm. All rights reserved.
//

#import "SoundPlayer.h"
#import <AVFoundation/AVFoundation.h>
@implementation SoundPlayer
-(void)play:(NSString *)textString volume:(float)volume rate:(float)rate pitchMultiplier:(float)pitchMultiplier{

    AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:textString];  //需要转换的文本
    utterance.rate = volume;
    utterance.voice=[AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];//设置语言
    utterance.rate = rate;
    utterance.pitchMultiplier = pitchMultiplier;
    [av speakUtterance:utterance];




}
@end
