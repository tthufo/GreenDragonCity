//
//  AP_Inner_Video_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 4/17/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "AP_Inner_Video_ViewController.h"

#import "LBYouTubeExtractor.h"

#import "XCDYouTubeClient.h"

#import <AVFoundation/AVFoundation.h>

#import <AVKit/AVKit.h>

#import "XCDYouTubeVideoPlayerViewController.h"

@interface AP_Inner_Video_ViewController ()<LBYouTubeExtractorDelegate>
{
    IBOutlet UITableView * tableView;
    
    NSMutableArray * dataList;
}

@end

@implementation AP_Inner_Video_ViewController

@synthesize info;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataList = [@[] mutableCopy];
    
    if([info responseForKey:@"videos"] && ![info[@"videos"] isKindOfClass:[NSString class]])
    {
        [dataList addObjectsFromArray:info[@"videos"]];
    }
    
    [tableView withCell:@"E_Empty_Music"];
    
    [tableView withCell:@"E_Search_Cell"];
    
    [tableView cellVisible];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? tableView.frame.size.height : 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count == 0 ? 1 : dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier: dataList.count == 0 ? @"E_Empty_Music" : @"E_Search_Cell"];
    
    if (!cell)
    {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:nil options:nil][2];
    }
    
    if(dataList.count == 0)
    {
        ((UILabel*)[self withView:cell tag:11]).text = @"Danh sách trống";
        
        return cell;
    }
    
    [(UILabel*)[self withView:cell tag:11] setText:dataList[indexPath.row][@"name"]];

    return cell;
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

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor didSuccessfullyExtractYouTubeURL:(NSURL *)videoURL
{
    NSLog(@"+++++%@", videoURL);
}

-(void)youTubeExtractor:(LBYouTubeExtractor *)extractor failedExtractingYouTubeURLWithError:(NSError *)error
{
    NSLog(@"-----%@", error);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(dataList.count == 0)
    {
        return;
    }
    
    NSString * url = dataList[indexPath.row][@"video_path"];
    
//    NSString * url = @"https://www.youtube.com/watch?v=lqVrILu61Is&feature=youtu. ";
    
//    LBYouTubeExtractor * extractor = [[LBYouTubeExtractor alloc] initWithURL:[NSURL URLWithString:url] quality:LBYouTubeVideoQualityMedium];
//    extractor.delegate = self;
//    [extractor startExtracting];
    
//    NSString * url = @"http://techslides.com/demos/sample-videos/small.mp4";

    //NSString * url = @"https://www.youtube.com/watch?v=lqVrILu61Is";
    
    
    if([url myContainsString:@"youtube"])
    {
        [self showSVHUD:@"Đang tải" andOption:0];
        
        NSString * ident = [self link:url];
        
        if(![self link:url])
        {
            [self alert:@"Thông báo" message:@"Video đang được cập nhật, mời bạn thử lại sau"];

            return;
        }
        
//        XCDYouTubeVideoPlayerViewController *videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:ident];
//        [self presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
//
//
        [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:ident completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {

            [self hideSVHUD];

            if (video)
            {
                NSDictionary *streamURLs = video.streamURLs;
                NSURL *streamURL = streamURLs[@(XCDYouTubeVideoQualityMedium360)] ;

                AVPlayer *player = [AVPlayer playerWithURL:streamURL];
                AVPlayerViewController *playerViewController = [AVPlayerViewController new];
                playerViewController.player = player;
                [self presentViewController:playerViewController animated:YES completion:^{
                    [playerViewController.player play];
                }];


//                MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:streamURL];
//
//                [self presentViewController:player animated:YES completion:^{
//
//                }];
//
//                [player.moviePlayer prepareToPlay];
//
//                [player.moviePlayer play];
            }
            else
            {
                NSLog(@"ko dc");
            }
        }];
        
//        [[YouTube share] returnUrl:ident andCompletion:^(int index, NSDictionary *info) {
//
//            [self hideSVHUD];
//
//            if(index != 0)
//            {
//                [self alert:@"Thông báo" message:@"Video đang được cập nhật, mời bạn thử lại sau"];
//
//                return;
//            }
//
//            if(index == 0)
//            {
//                MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:info[@"url"]];
//
//                [self presentViewController:player animated:YES completion:^{
//
//                }];
//
//                [player.moviePlayer prepareToPlay];
//
//                [player.moviePlayer play];
//            }
//
//        }];
    }
    else
    {
        MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:[url encodeUrl]]];
        
        [self presentViewController:player animated:YES completion:^{
            
        }];
        
        [player.moviePlayer prepareToPlay];
        
        [player.moviePlayer play];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
