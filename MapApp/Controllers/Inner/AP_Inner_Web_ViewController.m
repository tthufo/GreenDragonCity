//
//  AP_Inner_Web_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 4/17/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "AP_Inner_Web_ViewController.h"

#import <WebKit/WebKit.h>

@interface AP_Inner_Web_ViewController ()
{
    IBOutlet WKWebView * webView;
    
    IBOutlet UITableView * tableView;
    
    NSArray * keys;
    
    NSMutableDictionary * dict;
}

@end

@implementation AP_Inner_Web_ViewController

@synthesize info;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [tableView withCell:@"Inner_Cell_Web"];
    
    if([info[@"type"] isEqualToString:@"0"])
    {
        [webView loadHTMLString:![info responseForKey:@"ten_lo"] ? [info getValueFromKey:@"description"] : [self html:[NSString stringWithFormat:@"Mã lô: %@ <br />Trạng thái: <font style=\"color:%@;\">%@</font><br />Diện tích: %@ m2<br />%@<br />%@", [info getValueFromKey:@"ki_hieu"], [self status:[info getValueFromKey:@"tinh_trang_id"]][@"color"], [self status:[info getValueFromKey:@"tinh_trang_id"]][@"status"], [info getValueFromKey:@"dien_tich"], [info getValueFromKey:@"description"], [info[@"info"] isEqualToString:@""] ? @"Trạng thái đang được cập nhật" : [[info getValueFromKey:@"info"] stringByReplacingOccurrencesOfString:@"\n"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        withString:@"<br />"]]] baseURL:nil];
    }
    else 
    {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[info getValueFromKey:@"url_360"]]]];
    }
    
    keys = @[@"Mã lô", @"Trạng thái", @"Diện tích", @"Diện tích XD lô đất (m2)", @"Tổng diện tích sàn XD (m2)", @"Tầng cao tối đa", @"Mặt đường (m)", @"View", @"Hướng", @"Lô thường/Góc "];
    
    dict = [[NSMutableDictionary alloc] initWithDictionary: info[@"data"]];
    dict[@"Mã lô"] = [info getValueFromKey:@"ki_hieu"];
    dict[@"Trạng thái"] = [self status:[info getValueFromKey:@"tinh_trang_id"]][@"status"];
    dict[@"Diện tích"] = [info getValueFromKey:@"dien_tich"];
}

- (NSDictionary*)status:(NSString*)statusId
{
    return @{@"color":[statusId isEqualToString:@"1"] ? @"Green" : [statusId isEqualToString:@"2"] ? @"Red" : [statusId isEqualToString:@"3"] ? @"Blue" : @"Yellow", @"status":[statusId isEqualToString:@"1"] ? @"Chưa đăng ký" : [statusId isEqualToString:@"2"] ? @"Đã đăng ký" : [statusId isEqualToString:@"3"] ? @"Đã đặt cọc" : @"Đã khoá"};
}

- (NSDictionary*)statusColor:(NSString*)statusId
{
    return @{@"color":[statusId isEqualToString:@"1"] ? [UIColor systemGreenColor] : [statusId isEqualToString:@"2"] ? [UIColor systemRedColor] : [statusId isEqualToString:@"3"] ? [UIColor systemBlueColor] : [UIColor yellowColor], @"status":[statusId isEqualToString:@"1"] ? @"Chưa đăng ký" : [statusId isEqualToString:@"2"] ? @"Đã đăng ký" : [statusId isEqualToString:@"3"] ? @"Đã đặt cọc" : @"Đã khoá"};
}

- (NSString*)html:(NSString*)text
{
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.1, maximum-scale=1.1, minimum-scale=1.1, user-scalable=no'></header>";

    return [headerString stringByAppendingString:[NSString stringWithFormat:@"<html>%@</html>", text]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//Mã lô:
//Trạng thái:
//Diện tích:\
//Diện tích XD lô đất (m2)
//Tổng diện tích sàn XD:
//Tầng cao tối đa:
//Mặt đường (m)
//View
//Hướng
//Lô thường/Góc


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return keys.count;
}

- (UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Inner_Cell_Web" forIndexPath:indexPath];

//    NSDictionary * dict = dataList[indexPath.row];
//
    UILabel * name = (UILabel*)[self withView:cell tag:11];
    
    name.text = keys[indexPath.row];
    
    UILabel * value = (UILabel*)[self withView:cell tag:12];
    
    value.text = dict[keys[indexPath.row]];
    
    value.textColor = indexPath.row == 1 ? [self statusColor:[info getValueFromKey:@"tinh_trang_id"]][@"color"] : [UIColor blackColor];
//
//      [menu setTitle:[NSString stringWithFormat:@"             %@", dict[@"description"]] forState:UIControlStateNormal];
//
//      UIView * view = (UIView*)[self withView:cell tag:155];
//
//      UILabel * arrow = (UILabel*)[self withView:cell tag:989];
//
//      [menu actionForTouch:@{} and:^(NSDictionary *touchInfo) {
//          [self didPressRow:indexPath];
//          view.layer.borderWidth = 1;
//          arrow.textColor = [UIColor blackColor];
//      }];
//
//      [menu actionForTouchDown:@{} and:^() {
//          view.layer.borderWidth = 0;
//          arrow.textColor = [UIColor systemGreenColor];
//      }];
        
    return cell;
}

@end
