//
//  AP_List_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 5/3/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

#import "AP_List_ViewController.h"

#import "AP_Web_List_ViewController.h"

#import "XCDYouTubeClient.h"

#import <AVFoundation/AVFoundation.h>

#import <AVKit/AVKit.h>

@interface AP_List_ViewController ()
{
    IBOutlet NSLayoutConstraint * topBar;
    
    IBOutlet UITableView * tableView;
    
    NSMutableArray * dataList;
    
    IBOutlet UILabel * titleLabel;
}

@end

@implementation AP_List_ViewController

@synthesize label;

- (void)viewDidLoad
{
    [super viewDidLoad];

    titleLabel.text = label;

    dataList = [@[] mutableCopy];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11"))
    {
        topBar.constant = 44;
    }
    else
    {
        topBar.constant = 64;
    }
    
    [tableView withCell:@"E_Empty_Music"];
    
    [tableView withCell:@"Option_Cell_New"];
    
    if([label isEqualToString:@"TIN TỨC"])
    {
        [[LTRequest sharedInstance] didRequestInfo:@{@"CMD_CODE":@"api/news",
                                                     @"overrideAlert":@(1),
                                                     @"method":@"GET"
                                                     } withCache:^(NSString *cacheString) {
                                                         
                                                     } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated, NSDictionary* header) {
                                                         
                                                         if([errorCode isEqualToString:@"200"])
                                                         {
                                                             NSString * loInfo = responseString;
                                                             
                                                             [dataList addObjectsFromArray:[loInfo objectFromJSONString][@"array"]];
                                                         }
                                                         
                                                         [tableView cellVisible];
                                                     }];
    }
    else
    {
        if([label isEqualToString:@"VIDEOS"])
        {
            [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":@"http://45.117.169.237/layer/LL-CD27B89C/video",
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
                                                
                [dataList addObjectsFromArray:[responseString objectFromJSONString][@"array"]];
        
                [tableView cellVisible];
            }];
        }
        
//        NSError *error;
//        NSString *strFileContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
//                                                                       pathForResource: [label isEqualToString:@"TIN TỨC"] ? @"news" : [label isEqualToString:@"VIDEOS"] ? @"videos" : @"horoscope" ofType: @"txt"] encoding:NSUTF8StringEncoding error:&error];
//
//        [dataList addObjectsFromArray:[strFileContent objectFromJSONString]];
//
//        [tableView cellVisible];
        
//        - video: http://45.117.169.237/layer/LL-CD27B89C/video
    }
}

- (IBAction)didPressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return dataList.count == 0 ? tableView.frame.size.height : 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count ;//== 0 ? 1 : dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier: dataList.count == 0 ? @"E_Empty_Music" : @"Option_Cell_New"];
//
//    if (!cell)
//    {
//        cell = [[NSBundle mainBundle] loadNibNamed:@"EM_Menu" owner:nil options:nil][2];
//    }
//
//    if(dataList.count == 0)
//    {
//        ((UILabel*)[self withView:cell tag:11]).text = @"Danh sách trống";
//
//        return cell;
//    }
//
//    if([label isEqualToString:@"VIDEOS"])
//    {
//        ((UIImageView*)[self withView:cell tag:11]).image = [UIImage imageNamed:@"video_xanh"];
//
//        [(UILabel*)[self withView:cell tag:12] setText:dataList[indexPath.row][@"description"]];
//    }
//    else
//    {
//        [(UIImageView*)[self withView:cell tag:11] imageUrl:[dataList[indexPath.row][@"avatar"] encodeUrl]];
//    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option_Cell_New" forIndexPath:indexPath];

       NSDictionary * dict = dataList[indexPath.row];
       
       UIButton * menu = (UIButton*)[self withView:cell tag:12];
          
          [menu setTitle:[NSString stringWithFormat:@"               %@", dict[@"description"]] forState:UIControlStateNormal];

          UIView * view = (UIView*)[self withView:cell tag:155];
          
          UILabel * arrow = (UILabel*)[self withView:cell tag:989];

          [menu actionForTouch:@{} and:^(NSDictionary *touchInfo) {
              [self didPressRow:indexPath];
              view.layer.borderWidth = 1;
              arrow.textColor = [UIColor blackColor];
          }];
          
          [menu actionForTouchDown:@{} and:^() {
              view.layer.borderWidth = 0;
              arrow.textColor = [UIColor systemGreenColor];
          }];
        
    return cell;
}

- (void)didPressRow:(NSIndexPath*)indexPath {
    NSString * content = dataList[indexPath.row][@"url"];
       
       if([label isEqualToString:@"VIDEOS"])
       {
           [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:[self link:content] completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
               
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
               }
               else
               {
                   [self alert:@"Thông báo" message:error.localizedDescription];
               }
           }];
       }
       else
       {
           AP_Web_List_ViewController * web = [AP_Web_List_ViewController new];
           
           web.content = content;
           
           web.label = dataList[indexPath.row][@"title"];
           
           [self.navigationController pushViewController:web animated:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(dataList.count == 0)
    {
        return;
    }
    
//    NSString * content = dataList[indexPath.row][@"url"];
//
//    if([label isEqualToString:@"VIDEOS"])
//    {
//        [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:[self link:content] completionHandler:^(XCDYouTubeVideo * _Nullable video, NSError * _Nullable error) {
//
//            [self hideSVHUD];
//
//            if (video)
//            {
//                NSDictionary *streamURLs = video.streamURLs;
//                NSURL *streamURL = streamURLs[@(XCDYouTubeVideoQualityMedium360)] ;
//
//                AVPlayer *player = [AVPlayer playerWithURL:streamURL];
//                AVPlayerViewController *playerViewController = [AVPlayerViewController new];
//                playerViewController.player = player;
//                [self presentViewController:playerViewController animated:YES completion:^{
//                    [playerViewController.player play];
//                }];
//            }
//            else
//            {
//                [self alert:@"Thông báo" message:error.localizedDescription];
//            }
//        }];
//    }
//    else
//    {
//        AP_Web_List_ViewController * web = [AP_Web_List_ViewController new];
//
//        web.content = content;
//
//        web.label = dataList[indexPath.row][@"title"];
//
//        [self.navigationController pushViewController:web animated:YES];
//    }
}

@end
