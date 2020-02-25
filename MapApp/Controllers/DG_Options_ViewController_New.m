//
//  DG_Options_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 12/31/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

#import "DG_Options_ViewController_New.h"

#import "AP_Gallery_ViewController.h"

@interface DG_Options_ViewController_New ()<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet NSLayoutConstraint * top;
    
    IBOutlet UITableView * tableView;
    
    IBOutlet UILabel * titleLabelTop;

    NSMutableArray * dataList;
    
    NSString * uId;
}

@end

@implementation DG_Options_ViewController_New

@synthesize isHide, titleLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataList = [NSMutableArray new];
    
    uId = @"ll-CD27B89C";
    
    [tableView withCell:@"Option_Cell"];
    
    titleLabelTop.text = titleLabel;
    
//    top.constant = isHide ? 0 : SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11") ? 44 : 64;
    
//    if ([isHide isEqualToString:@""]) {
//        
//    } else {
        [self didRequestOptions];
//    }
}

- (IBAction)didPressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRequestPicture:(NSString*) albumId andTitle: (NSString*) title{
    NSString * url = [NSString stringWithFormat: @"http://45.117.169.237/layer/%@/album/%@", uId, albumId];
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink": url,
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
    
                                                         AP_Gallery_ViewController * gallery = [AP_Gallery_ViewController new];
    
                                                         gallery.info = [responseString objectFromJSONString];
    
                                                         gallery.titleLabel = title;
                                                         
                                                         [self.navigationController pushViewController:gallery animated:true];
                                                     }];
}

- (void)didRequestOptions
{
    NSString * url = !isHide ? [NSString stringWithFormat: @"http://45.117.169.237/album/layer/%@", uId] : [NSString stringWithFormat: @"http://45.117.169.237/album/layer/%@?sub_id=%@", uId, isHide];
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink": url,
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
                                                     
                                                     [dataList removeAllObjects];
                                                     
                                                     [dataList addObjectsFromArray: [responseString objectFromJSONString][@"array"]];
                                                     
                                                     [tableView reloadData];
                                                                                                         
                                                 }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Option_Cell" forIndexPath:indexPath];

    NSDictionary * dict = dataList[indexPath.row];
    
    [(UILabel*)[self withView:cell tag:12] setText:[NSString stringWithFormat:@"   %@", dict[@"description"]]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = dataList[indexPath.row];
        
    if ([[dict getValueFromKey:@"has_sub_album"] isEqualToString:@"1"]) {
        DG_Options_ViewController_New * option = [DG_Options_ViewController_New new];
        
        option.isHide = [dict getValueFromKey:@"id"];
        
        option.titleLabel = dict[@"description"];
        
        [self.navigationController pushViewController:option animated:YES];
    } else {
        [self didRequestPicture:dict[@"id"] andTitle: dict[@"description"]];
    }
}

@end
