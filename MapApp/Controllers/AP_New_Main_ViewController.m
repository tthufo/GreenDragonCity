//
//  AP_New_Main_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 5/2/19.
//  Copyright © 2019 Thanh Hai Tran. All rights reserved.
//

#import "AP_New_Main_ViewController.h"

#import "AP_Map_ViewController.h"

#import "AP_Gallery_ViewController.h"

#import "AP_List_ViewController.h"

#import "AP_Web_List_ViewController.h"

@interface AP_New_Main_ViewController ()
{
    IBOutlet UITableView * tableView;
    
    IBOutlet UIButton * logOut;
    
    NSMutableArray * dataList;
}

@end

@implementation AP_New_Main_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    dataList = [@[@{@"img":@"icon tranh chinh", @"title":@"TRANG CHỦ"}, @{@"img":@"icon anh", @"title":@"ẢNH"}, @{@"img":@"icon video", @"title":@"VIDEOS"}, @{@"img":@"icon phong thuy", @"title":@"TRẢI NGHIỆM 360"}, @{@"img":@"icon tin tuc", @"title":@"TIN TỨC"}] mutableCopy];
    
    [tableView withCell:@"E_Main_Menu"];
    
    logOut.alpha = [[ObjectInfo shareInstance].login isEqualToString:@"Yes"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)OrientationDidChange:(NSNotification*)notification
{
    NSLog(@"%@", notification);
}

- (IBAction)didPressLogOut:(id)sender
{
    [[DropAlert shareInstance] alertWithInfor:@{@"title":@"Thông báo", @"message":@"Bạn có muốn đăng xuất ra khỏi tài khoản này?", @"buttons":@[@"Đăng xuất"], @"cancel":@"Thoát"} andCompletion:^(int indexButton, id object) {
        
        if(indexButton == 0)
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        
            [self removeObject:@"setting"];
        }
        
    }];
}

- (void)didPressImages
{
    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":@"http://45.117.169.237/layer/ll-2D1B168C/images/",
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
                                                     
                                                     [self.navigationController pushViewController:gallery animated:true];
                                                 }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"E_Main_Menu" forIndexPath: indexPath];
    
    NSDictionary * dict = dataList[indexPath.row];
    
    ((UIImageView*)[self withView:cell tag:11]).image = [UIImage imageNamed:dict[@"img"]];
    
    ((UILabel*)[self withView:cell tag:12]).text = dict[@"title"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dict = dataList[indexPath.row];

    AP_List_ViewController * list = [AP_List_ViewController new];
    
    list.label = dict[@"title"];

    switch (indexPath.row)
    {
        case 0:
            [self.navigationController pushViewController:[AP_Map_ViewController new] animated:YES];
            break;
        case 1:
            [self didPressImages];
            break;
        case 3:
        {
            AP_Web_List_ViewController * web = [AP_Web_List_ViewController new];
            
            web.url = @"http://3dartvn.com/submission/dameva%20residences/360/16-3-2019/";
            
            web.label = dict[@"title"];
            
            [self.navigationController pushViewController:web animated:YES];
        }
            break;
        case 2:
        case 4:
            [self.navigationController pushViewController:list animated:YES];
            break;
        default:
            break;
    }
}

@end
