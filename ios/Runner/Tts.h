//
//  Tts.h
//  Runner
//
//  Created by 张浩 on 2019/12/20.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#ifndef Tts_h
#define Tts_h


#endif /* Tts_h */

#import <Flutter/Flutter.h>
@import AVFoundation;

@interface FlutterPluginTtsPlugin : NSObject<FlutterPlugin>
@property (readwrite, nonatomic, strong) AVSpeechSynthesizer *speechSynthesizer;
@property (strong) NSString *locale;
@property (assign) float rate;
@end
