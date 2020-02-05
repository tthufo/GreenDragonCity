//
//  AP_Info_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 5/22/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "AP_Inner_Info_ViewController.h"

#import "AP_Web_ViewController.h"


@interface AP_Inner_Info_ViewController ()
{
    IBOutlet UITableView * tableView;
    
    NSMutableArray * dataList;
}
@end

@implementation AP_Inner_Info_ViewController

@synthesize pointInfo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSDictionary * path = @{@"0":@{@"key":@"link_new_items", @"name":@"Bảng hàng cập nhật mới nhất"},
//                            @"1":@{@"key":@"link_price", @"name":@"Giá - Chính sách giao dịch (CSBH)"},
//                            @"2":@{@"key":@"link_video_images", @"name":@"Phim Dự án + Ảnh thực tế:"},
//                            @"3":@{@"key":@"link_concept", @"name":@"Concept Design của dự án"},
//                            @"4":@{@"key":@"link_ground", @"name":@"Mặt bằng QH-TK"},
//                            @"5":@{@"key":@"link_progress", @"name":@"Tiến độ dự án"},
//                            @"6":@{@"key":@"link_contract", @"name":@"Mẫu hợp đồng"},
//                            @"7":@{@"key":@"link_brochure", @"name":@"Tài liệu in ấn - Tờ gấp, Short Brochure"},
//                            @"8":@{@"key":@"link_training", @"name":@"File training dự án"},
//                            };
//
//    NSMutableArray * array = [NSMutableArray new];
//
//    for(NSDictionary * value in path.allValues) {
//        for(NSString * key in pointInfo){
//            if([key isEqualToString:value[@"key"]] && ![[pointInfo getValueFromKey:key] isEqualToString:@""]) {
//                [array addObject:@{@"name":value[@"name"], @"link":pointInfo[key]}];
//            }
//        }
//    }
    
    dataList = [NSMutableArray new];
    
//    dataList = [@[@{@"name":@"Bảng hàng cập nhật mới nhất", @"link":@"https://goo.gl/f5KEQw"}, @{@"name":@"Giá - Chính sách giao dịch (CSBH)", @"link":@"https://goo.gl/EKqG8R"}, @{@"name":@"Phim Dự án + Ảnh thực tế:", @"link":@"https://goo.gl/icmKWm"}, @{@"name":@"Concept Design của dự án", @"link":@"https://goo.gl/c2qJsh"}, @{@"name":@"Mặt bằng QH-TK", @"link":@"https://goo.gl/RQTRXL"}, @{@"name":@"Tiến độ dự án", @"link":@"https://goo.gl/Jt4QnT"}, @{@"name":@"Mẫu hợp đồng", @"link":@"https://goo.gl/N3Na75"}, @{@"name":@"Tài liệu in ấn - Tờ gấp, Short Brochure", @"link":@"https://goo.gl/PTTKBq"}, @{@"name":@"File training dự án", @"link":@"https://goo.gl/iuFCQj"}] mutableCopy];
    
    [tableView withCell:@"E_Empty_Music"];
    
    [tableView withCell:@"E_Search_Cell"];
    
    [tableView cellVisible];
    
    [self didRequestForList];
}

- (void)didRequestForList
{
    NSDictionary * infoPlist = [self dictWithPlist:@"Info"];
    
    NSMutableDictionary * dict = [@{@"absoluteLink":[NSString stringWithFormat:@"%@/point/lo/info/%@", infoPlist[@"host"], [pointInfo getValueFromKey:@"gid"]],
                                    @"method":@"GET",
                                    @"host":self,
                                    @"overrideLoading":@(1),
                                    @"overrideAlert":@(1),
                                    } mutableCopy];
    
    [[LTRequest sharedInstance] didRequestInfo:dict withCache:^(NSString *cacheString) {
    } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated, NSDictionary* header) {
        
        if(!responseString)
        {
            return;
        }
        
        if([errorCode isEqualToString:@"200"])
        {
            [dataList removeAllObjects];
            
            NSDictionary * path = @{@"0":@{@"key":@"link_new_items", @"name":@"Bảng hàng cập nhật mới nhất"},
                                    @"1":@{@"key":@"link_price", @"name":@"Giá - Chính sách giao dịch (CSBH)"},
                                    @"2":@{@"key":@"link_video_images", @"name":@"Phim Dự án + Ảnh thực tế:"},
                                    @"3":@{@"key":@"link_concept", @"name":@"Concept Design của dự án"},
                                    @"4":@{@"key":@"link_ground", @"name":@"Mặt bằng QH-TK"},
                                    @"5":@{@"key":@"link_progress", @"name":@"Tiến độ dự án"},
                                    @"6":@{@"key":@"link_contract", @"name":@"Mẫu hợp đồng"},
                                    @"7":@{@"key":@"link_brochure", @"name":@"Tài liệu in ấn - Tờ gấp, Short Brochure"},
                                    @"8":@{@"key":@"link_training", @"name":@"File training dự án"},
                                    };
            
            NSMutableArray * array = [NSMutableArray new];
            
            for(NSDictionary * value in path.allValues) {
                for(NSString * key in pointInfo){
                    if([key isEqualToString:value[@"key"]] && ![[pointInfo getValueFromKey:key] isEqualToString:@""]) {
                        [array addObject:@{@"name":value[@"name"], @"link":pointInfo[key]}];
                    }
                }
            }
            
            [dataList addObjectsFromArray:array];
        }
        
        [tableView cellVisible];
    }];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(dataList.count == 0)
    {
        return;
    }
    
    NSString * url = dataList[indexPath.row][@"link"];
    
    [(AP_Web_ViewController*)self.parentViewController.parentViewController didOpenWeb:url];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
