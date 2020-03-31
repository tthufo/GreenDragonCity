//
//  DashBoard_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 3/31/20.
//  Copyright © 2020 Thanh Hai Tran. All rights reserved.
//

#import "DashBoard_ViewController.h"

#import "XCDYouTubeClient.h"

#import <AVFoundation/AVFoundation.h>

#import <AVKit/AVKit.h>

#import "AP_Map_ViewController.h"

#import "DG_Options_ViewController_New.h"

#import "AP_Web_List_ViewController.h"

#import "AP_List_ViewController.h"

@interface DashBoard_ViewController ()
{
    IBOutlet NSLayoutConstraint * bottomHeight;
    
    IBOutlet UIView * playerView;
    
    AVPlayer * avPlayer;
    
    BOOL isOn;
}

@end

@implementation DashBoard_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    bottomHeight.constant = [self screenHeight] * 0.3;
    
    isOn = YES;
    
    NSString * ident = [self link: @"https://www.youtube.com/watch?v=wfOmJmopka0&feature=youtu.be"];
       
       [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:ident completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {

           if (video)
           {
               NSDictionary *streamURLs = video.streamURLs;
               NSURL *streamURL = streamURLs[@(XCDYouTubeVideoQualityMedium360)] ;

               AVAsset *asset = [AVAsset assetWithURL: streamURL];

                   // *** Create AVPlayerItem using AVAsset ***
               AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];

               // *** Initialise AVPlayer ***
               avPlayer = [AVPlayer playerWithPlayerItem:playerItem];

               // *** Add AVPlayer to ViewController ***
               AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
               avPlayerLayer.frame = CGRectMake(0, 0, [self screenWidth], playerView.frame.size.height);
               [avPlayerLayer setBackgroundColor:[UIColor clearColor].CGColor];
               
               [playerView.layer addSublayer:avPlayerLayer];

               avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

               // *** Start Playback ***
               [avPlayer play];

           //     *** Register for playback end notification ***
               [[NSNotificationCenter defaultCenter] addObserver:self
                                                        selector:@selector(playerItemDidReachEnd:)
                                                            name:AVPlayerItemDidPlayToEndTimeNotification
                                                          object:[avPlayer currentItem]];

               // *** Register observer for events of AVPlayer status ***
               [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
           }
           else
           {
               NSLog(@"ko dc");
           }
       }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [avPlayer pause];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
        
    if (avPlayer) {
        [avPlayer play];
    }
    
//    NSString * ident = [self link: @"https://www.youtube.com/watch?v=wfOmJmopka0&feature=youtu.be"];
//
//    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:ident completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
//
//        if (video)
//        {
//            NSDictionary *streamURLs = video.streamURLs;
//            NSURL *streamURL = streamURLs[@(XCDYouTubeVideoQualityMedium360)] ;
//
//            AVAsset *asset = [AVAsset assetWithURL: streamURL];
//
//                // *** Create AVPlayerItem using AVAsset ***
//            AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
//
//            // *** Initialise AVPlayer ***
//            avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
//
//            // *** Add AVPlayer to ViewController ***
//            AVPlayerLayer *avPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:avPlayer];
//            avPlayerLayer.frame = CGRectMake(0, 0, [self screenWidth], playerView.frame.size.height);
//            [avPlayerLayer setBackgroundColor:[UIColor clearColor].CGColor];
//
//            [playerView.layer addSublayer:avPlayerLayer];
//
//            avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
//
//            // *** Start Playback ***
//            [avPlayer play];
//
//        //     *** Register for playback end notification ***
//            [[NSNotificationCenter defaultCenter] addObserver:self
//                                                     selector:@selector(playerItemDidReachEnd:)
//                                                         name:AVPlayerItemDidPlayToEndTimeNotification
//                                                       object:[avPlayer currentItem]];
//
//            // *** Register observer for events of AVPlayer status ***
//            [avPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
//        }
//        else
//        {
//            NSLog(@"ko dc");
//        }
//    }];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [avPlayer seekToTime:kCMTimeZero];
    [avPlayer play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if (object == avPlayer && [keyPath isEqualToString:@"status"]) {
        if (avPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
        } else if (avPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [avPlayer play];
        } else if (avPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
        }
    }
}

- (NSString *)link:(NSString *)link {
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}

- (IBAction)didPressSound:(UIButton *)sender {
    
    [sender setImage:[UIImage imageNamed: isOn ? @"sound_in" : @"sound_ac"] forState:UIControlStateNormal];
    
    isOn = !isOn;
}

- (IBAction)didPressButton:(UIButton *)sender {
    AP_Web_List_ViewController * web = [AP_Web_List_ViewController new];

    switch (sender.tag) {
        case 11:
        {
            web.label = @"Giới thiệu";
            
            web.url = @"http://45.117.169.237/upload/documents/gioi-thieu.html";
            
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
            case 12:
        {
            web.label = @"Quy mô";
            
            web.url = @"http://45.117.169.237/upload/documents/quy-mo.html";
            
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
            case 13:
        {
            web.label = @"Vị trí";
            
            web.url = @"http://45.117.169.237/upload/documents/vi-tri.html";
            
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
            case 14:
        {
            AP_List_ViewController * web = [AP_List_ViewController new];

            web.label = @"Sản phẩm";

            [self.navigationController pushViewController:web animated:YES];
        }
            break;
            case 15:
        {
            web.label = @"Tiện ích";
            
            web.url = @"http://45.117.169.237/upload/documents/tien-ich.html";
            
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
            case 16:
        {
            web.label = @"Chủ đầu tư";
            
            web.url = @"http://45.117.169.237/upload/documents/chu-dau-tu.html";
            
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
            case 17:
        {
            [self.navigationController pushViewController:[AP_Map_ViewController new] animated:YES];
        }
            break;
            break;
            case 18:
        {
            [self didPressImages];
        }
            break;
            case 19:
        {
            AP_List_ViewController * list = [AP_List_ViewController new];
            
            list.label = @"Video";//dict[@"title"];
            
            [self.navigationController pushViewController:list animated:YES];
        }
            break;
            case 20:
        {
            [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":@"http://45.117.169.237/layer/LL-CD27B89C/360",
            @"method":@"GET",
            @"overrideLoading":@(1),
            @"host":self,
            @"overrideAlert":@(1)
            } withCache:^(NSString *cacheString) {
                
            } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated, NSDictionary* header) {
                
                if(![errorCode isEqualToString:@"200"])
                {
                    [self showToast:@"Lỗi xảy ra, mời bạn thử lại sau" andPos:0];
                    
                    return ;
                }
                
                AP_Web_List_ViewController * web = [AP_Web_List_ViewController new];

                web.url = [[[responseString objectFromJSONString][@"array"] firstObject] getValueFromKey:@"url"] ;

                web.label = @"360 Tour";//dict[@"title"];

                [self.navigationController pushViewController:web animated:YES];
            }];
        }
            break;
            case 21:
        {
            AP_Web_List_ViewController * web = [AP_Web_List_ViewController new];
            
            web.label = @"Tài liệu bán hàng";
            
            web.url = @"https://drive.google.com/drive/u/0/folders/1ffzdlFMJFqpnMb7TjBQaNDbnH2EZfdNT";
            
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didPressImages
{
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":@"http://45.117.169.237/album/layer/LL-CD27B89C",
                                                 @"method":@"GET",
                                                 @"overrideLoading":@(1),
                                                 @"host":self,
                                                 @"overrideAlert":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated, NSDictionary* header) {
                                                     
                                                     if(![errorCode isEqualToString:@"200"])
                                                     {
                                                         [self showToast:@"Lỗi xảy ra, mời bạn thử lại sau" andPos:0];
                                                         
                                                         return ;
                                                     }
                                                     
                                                     
                                                     DG_Options_ViewController_New * option = [DG_Options_ViewController_New new];
                                                     
                                                     option.titleLabel = @"Ảnh dự án";
                                                     
                                                     [self.navigationController pushViewController:option animated:true];
                                                 }];
}


@end