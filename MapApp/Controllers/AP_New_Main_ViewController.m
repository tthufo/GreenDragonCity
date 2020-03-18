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

#import "DG_Options_ViewController_New.h"

#import "AVHexColor.h"

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
    
    dataList = [@[
        @{@"img":@"home_xanh", @"title":@"TRANG CHỦ",
          @"img_down":@"home_trang",
          @"title_down":@"#00783C",
          @"title_up":@"#ffffff"},
  @{@"img":@"image_xanh", @"title":@"ẢNH",
    @"img_down":@"image_trang",
    @"title_down":@"#00783C",
    @"title_up":@"#ffffff"
  },
  @{@"img":@"video_xanh", @"title":@"VIDEOS",
    @"img_down":@"video_trang",
    @"title_down":@"#00783C",
    @"title_up":@"#ffffff"
  },
  @{@"img":@"360_xanh", @"title":@"TRẢI NGHIỆM 360",
    @"img_down":@"360_trang",
    @"title_down":@"#00783C",
    @"title_up":@"#ffffff"
  },
  @{@"img":@"folder_xanh", @"title":@"TÀI LIỆU BÁN HÀNG",
    @"img_down":@"folder_trang",
    @"title_down":@"#00783C",
    @"title_up":@"#ffffff"
  }] mutableCopy];
    
    [tableView withCell:@"E_Main_Button_View"];
    
    logOut.alpha = [[ObjectInfo shareInstance].login isEqualToString:@"Yes"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(OrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)OrientationDidChange:(NSNotification*)notification
{
    NSLog(@"%@", notification);
}

- (IBAction)didPressLogOut:(id)sender
{
    EM_MenuView * menuDialog = [[EM_MenuView alloc] initWithMenuOut:@{}];

    [self.view endEditing:YES];
    
    [menuDialog showWithCompletion:^(int index, id object, EM_MenuView *menu) {
        switch (index) {
            case 0:
            {
                [[DropAlert shareInstance] alertWithInfor:@{@"title":@"Thông báo", @"message":@"Bạn có muốn đăng xuất ra khỏi tài khoản này?", @"buttons":@[@"Đăng xuất"], @"cancel":@"Thoát"} andCompletion:^(int indexButton, id object) {

                    if(indexButton == 0)
                    {
                        [self.navigationController popToRootViewControllerAnimated:YES];

                        [self removeObject:@"setting"];
                    }

                }];
            }
                break;
            case 1:
            {
                exit(0);
            }
                break;
            default:
                break;
        }
    }];
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

- (void)didPressRow:(NSDictionary*)dict andIndex:(int) indexing {
        AP_List_ViewController * list = [AP_List_ViewController new];
        
        list.label = dict[@"title"];

        switch (indexing)
        {
            case 0:
                [self.navigationController pushViewController:[AP_Map_ViewController new] animated:YES];
                break;
            case 1:
                [self didPressImages];
                break;
            case 3:
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

                    web.label = dict[@"title"];

                    [self.navigationController pushViewController:web animated:YES];
                }];
            }
                break;
            case 2:
            {
                [self.navigationController pushViewController:list animated:YES];
            }
                break;
            case 4:
            {
                AP_Web_List_ViewController * web = [AP_Web_List_ViewController new];
                
                web.label = @"Tài liệu bán hàng";
                
                web.url = @"https://drive.google.com/file/d/1dZetI0ypIzEjNRia5LYa29JQfNkePeG5/view";
                
                [self.navigationController pushViewController:web animated:YES];
            }
                break;
            default:
                break;
        }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"E_Main_Button_View" forIndexPath: indexPath];
    
    NSDictionary * dict = dataList[indexPath.row];

    UIImageView * ava = ((UIImageView*)[self withView:cell tag:11]);
    
    ava.image = [UIImage imageNamed:dict[@"img"]];

    UILabel * titles = ((UILabel*)[self withView:cell tag:12]);
    
    titles.text = dict[@"title"];
    
    UIButton * menu = ((UIButton*)[self withView:cell tag:10]);
    
    menu.accessibilityLabel = [dict bv_jsonStringWithPrettyPrint:YES];
    
    [menu actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        menu.backgroundColor = [AVHexColor colorWithHexString:dict[@"title_up"]];
        ava.image = [UIImage imageNamed:dict[@"img"]];
        titles.textColor = [AVHexColor colorWithHexString:dict[@"title_down"]];
        [self didPressRow:dict andIndex:indexPath.row];
    }];
    
    [menu actionForTouchDown:@{} and:^() {
        menu.backgroundColor = [AVHexColor colorWithHexString:dict[@"title_down"]];
        ava.image = [UIImage imageNamed:dict[@"img_down"]];
        titles.textColor = [AVHexColor colorWithHexString:dict[@"title_up"]];
    }];
    
    [menu addTarget:self action:@selector(didCanCelling:) forControlEvents:UIControlEventTouchDragExit];

    return cell;
}

- (void)didCanCelling:(UIButton*)sender {
    UIView * cell = sender.superview;
    
    NSDictionary * dict = [sender.accessibilityLabel objectFromJSONString];
    
    UIImageView * ava = ((UIImageView*)[self withView:cell tag:11]);
      

    UILabel * titles = ((UILabel*)[self withView:cell tag:12]);
  
  
    UIButton * menu = ((UIButton*)[self withView:cell tag:10]);
    
    menu.backgroundColor = [AVHexColor colorWithHexString:dict[@"title_up"]];
    ava.image = [UIImage imageNamed:dict[@"img"]];
    titles.textColor = [AVHexColor colorWithHexString:dict[@"title_down"]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        
//    ((UIImageView*)[self withView:cell tag:11]).image = [UIImage imageNamed:@""];
    
//    ((UILabel*)[self withView:cell tag:12]).text = @"haiba";
    
    
//    NSDictionary * dict = dataList[indexPath.row];

//    AP_List_ViewController * list = [AP_List_ViewController new];
//
//    list.label = dict[@"title"];
//
//    switch (indexPath.row)
//    {
//        case 0:
////            [self.navigationController pushViewController:[AP_Map_ViewController new] animated:YES];
//            break;
//        case 1:
////            [self didPressImages];
//            break;
//        case 3:
//        {
//            AP_Web_List_ViewController * web = [AP_Web_List_ViewController new];
//
//            web.url = @"http://3dartvn.com/submission/dameva%20residences/360/16-3-2019/";
//
//            web.label = dict[@"title"];
//
////            [self.navigationController pushViewController:web animated:YES];
//        }
//            break;
//        case 2:
//        case 4:
////            [self.navigationController pushViewController:list animated:YES];
//            break;
//        default:
//            break;
//    }
}

@end
