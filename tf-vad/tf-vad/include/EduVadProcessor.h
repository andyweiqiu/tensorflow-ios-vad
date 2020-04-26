//
//  EduVadProcessor.h
//  tf-vad
//
//  Created by 邱威 on 2019/12/31.
//  Copyright © 2019 qiuwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 vad检测
 说明：该vad检测是尾端vad检测。该检测器会检测到有持续声音输入后，才会开启尾端vad检测，
    如果在检测器启动后，一直没有有效的音频输入，则不会开启vad尾端检测。在检测到有效音频后，
    检测器会持续输出检测结果，isSilence为标志符，如果isSilence为YES，说明是静音，
    isSilence为NO，说明是有声。该检测器是对某一固定长音频（默认700毫秒，可通过设置vadInterval来进行调整）进行检测。
 */

@protocol EduVadProcessorDelegate <NSObject>

- (void)eduVadProcessorOnVad:(BOOL)isSilence;

@end

typedef void (^EduVadProcessorResultHandler) (BOOL isSilence);

@interface EduVadProcessor : NSObject

// vad结果回调的代理
@property (nonatomic, weak) id<EduVadProcessorDelegate> delegate;

// vad结果回调
@property (nonatomic, strong) EduVadProcessorResultHandler vadResultHandler;

// 设置尾端vad时长，默认700毫秒
@property (nonatomic, assign) NSTimeInterval vadInterval;

// 设置音频的采样率
@property (nonatomic, assign) NSInteger sampleRate;

+ (instancetype)sharedProcessor;

/**
 在程序启动时初始化
 */
- (void)initVadProcess;

/**
 外部传模型文件初始化
 */
- (void)initVadProcess:(NSString *)modelPath cmvnPath:(NSString *)cmvnPath;

/**
 启动vad检测
 */
- (void)start;

/**
 关闭vad检测
 */
- (void)stop;

/**
 接收音频流
 启动vad检测后，可以根据不同的音频流格式将音频传给检测器
 */
- (void)appendAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)appendAudioPCMBuffer:(AVAudioPCMBuffer *)audioPCMBuffer;
- (void)appendPCMData:(NSData *)pcmData;

@end

NS_ASSUME_NONNULL_END
