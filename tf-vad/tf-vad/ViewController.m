//
//  ViewController.m
//  tf-vad
//
//  Created by 邱威 on 2020/4/26.
//  Copyright © 2020 qiuwei. All rights reserved.
//

#import "ViewController.h"
#import "EduVadProcessor.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) AVCaptureSession *capture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *pbPath = [[NSBundle mainBundle] pathForResource:@"FLSTM_VAD_model_V2" ofType:@"pb"];

        NSString *cmvnPath = [[NSBundle mainBundle] pathForResource:@"mean_variance_v2" ofType:@"txt"];

        [[EduVadProcessor sharedProcessor] initVadProcess:pbPath cmvnPath:cmvnPath];

        // 设置vad大小
        [EduVadProcessor sharedProcessor].vadInterval = 500;
        [EduVadProcessor sharedProcessor].sampleRate = 44100;

        __weak typeof(self) weakSelf = self;
        [EduVadProcessor sharedProcessor].vadResultHandler = ^(BOOL isSilence) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.tipLabel.text = isSilence ? @"静音" : @"说话";
            });
        };
}

- (IBAction)startButtonClicked:(id)sender {
    [[EduVadProcessor sharedProcessor] start];
    [self startCapture];
}

- (IBAction)stopButtonClicked:(id)sender {
    [[EduVadProcessor sharedProcessor] stop];
    [self endCapture];
}

- (void)startCapture {
    self.capture = [AVCaptureSession new];

    AVCaptureDevice *audioDev = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];

    AVCaptureDeviceInput *audioIn = [[AVCaptureDeviceInput alloc] initWithDevice:audioDev error:nil];

    if (![self.capture canAddInput:audioIn]) {
        NSLog(@"不能添加 input device");
        return;
    }

    [self.capture addInput:audioIn];

    AVCaptureAudioDataOutput *audioOut = [AVCaptureAudioDataOutput new];

    [audioOut setSampleBufferDelegate:self queue:dispatch_get_main_queue()];//dispatch_get_global_queue(0, 0) dispatch_get_main_queue()

    if (![self.capture canAddOutput:audioOut]) {
        NSLog(@"不能添加 audio output");
        return;
    }

    [self.capture addOutput:audioOut];
    [audioOut connectionWithMediaType:AVMediaTypeAudio];
    //    dispatch_async(dispatch_get_main_queue(), ^{
    [self.capture startRunning];
    //    });
}

- (void)endCapture {
    if (self.capture.isRunning) {
        [self.capture stopRunning];
    }
}

#pragma mark - AVCaptureAudioDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    [[EduVadProcessor sharedProcessor] appendAudioSampleBuffer:sampleBuffer];
}


@end
