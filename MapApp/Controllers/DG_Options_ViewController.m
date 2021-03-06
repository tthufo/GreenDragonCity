//
//  DG_Options_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 12/31/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

#import "DG_Options_ViewController.h"

#import "AP_Gallery_ViewController.h"

@interface DG_Options_ViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet NSLayoutConstraint * top;
    
    IBOutlet UITableView * tableView;
    
    NSMutableArray * dataList;
    
    NSString * uId;
}

@end

@implementation DG_Options_ViewController

@synthesize isHide, gId;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataList = [NSMutableArray new];
    
    uId = @"ll-CD27B89C";
    
    [tableView withCell:@"Option_Cell"];
    
    top.constant = isHide ? 0 : SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11") ? 44 : 44;
    
    [self didRequestOptions];
}

- (IBAction)didPressOption:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)didPressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didRequestPicture:(NSString*) albumId andTitle: (NSString*) title{
    NSString * url = !isHide ? [NSString stringWithFormat: @"http://45.117.169.237/layer/%@/album/%@", uId, albumId] : [NSString stringWithFormat: @"http://45.117.169.237/point/%@/album/%@", gId, albumId];
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
    NSString * url = !isHide ? [NSString stringWithFormat: @"http://45.117.169.237/album/layer/%@", uId] : [NSString stringWithFormat: @"http://45.117.169.237/album/layer/%@/parcel", uId];
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
    
    UIButton * menu = (UIButton*)[self withView:cell tag:12];
       
       [menu setTitle:[NSString stringWithFormat:@"   %@", dict[@"description"]] forState:UIControlStateNormal];

       UIView * view = (UIView*)[self withView:cell tag:155];
       
       UILabel * arrow = (UILabel*)[self withView:cell tag:989];

       [menu actionForTouch:@{} and:^(NSDictionary *touchInfo) {
           [self didRequestPicture:dict[@"id"] andTitle: dict[@"description"]];
           view.layer.borderWidth = 1;
           arrow.textColor = [UIColor blackColor];
       }];
       
       [menu actionForTouchDown:@{} and:^() {
           view.layer.borderWidth = 0;
           arrow.textColor = [UIColor systemGreenColor];
       }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
