//
//  SoundPlayer.h
//  语音播报
//
//  Created by sfm on 16/6/18.
//  Copyright © 2016年 sfm. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SoundPlayer : NSObject

-(void)play:(NSString *)textString volume:(float)volume rate:(float)rate pitchMultiplier:(float)pitchMultiplier;
@end
