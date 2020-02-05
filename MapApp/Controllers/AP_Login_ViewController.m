//
//  AP_Login_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 4/9/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "AP_Login_ViewController.h"

#import "AP_Map_ViewController.h"

#import "AP_Register_ViewController.h"

#import "AP_New_Main_ViewController.h"

#import "XMLReader.h"

@interface AP_Login_ViewController ()<RegisterDelegate>
{
    IBOutlet UITextField * uName, * pass;
    
    IBOutlet UIButton * check;
    
    IBOutlet UITableView * tableView;
    
    IBOutlet UITableViewCell * cell;
    
    KeyBoard * kb;
}

@end

@implementation AP_Login_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableView.alpha = 0;
    
    if(![self getValue:@"check"])
    {
        [self addValue:@"1" andKey:@"check"];
    }

    [check setImage:[UIImage imageNamed: [[self getValue:@"check"] isEqualToString:@"1"] ? @"on" : @"off"] forState:UIControlStateNormal];
    
    [self.view actionForTouch:@{} and:^(NSDictionary *touchInfo) {
        [self.view endEditing:YES];
    }];
    
    if([[self getValue:@"check"] isEqualToString:@"1"])
    {
        uName.text = [self getValue:@"name"];

        pass.text = [self getValue:@"pass"];

        if([self getValue:@"name"] && [self getValue:@"pass"] && ![[self getValue:@"name"] isEqualToString:@""] && ![[self getValue:@"pass"] isEqualToString:@""])
        {
            [self didRequestLogin];
        }
    }
    
    [self didGoToMap];
    
    [self didRequestLayerList];
    
    NSDictionary *textAttributes =
    @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Tên đăng nhập"
                                    attributes:textAttributes];

    [uName setAttributedPlaceholder:attributedPlaceholder];
    
    
    NSDictionary *textAttributes1 =
    @{ NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *attributedPlaceholder1 =
    [[NSAttributedString alloc] initWithString:@"Mật khẩu"
                                    attributes:textAttributes1];

    [pass setAttributedPlaceholder:attributedPlaceholder1];
    
//    [[LTRequest sharedInstance] didRequestInfo:@{@"absoluteLink":@"https://dl.dropboxusercontent.com/s/f33ps6prcm6zr0n/MapApp_2.plist",@"overrideError":@(1),@"overrideLoading":@(1),@"host":self} withCache:^(NSString *cacheString) {
//    } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated) {
//
//        if(!isValidated)
//        {
            tableView.alpha = 1;
//
//            return ;
//        }
//
//        NSData *data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
//        NSError * er = nil;
//        NSDictionary *dict = [self returnDictionary:[XMLReader dictionaryForXMLData:data
//                                                                            options:XMLReaderOptionsProcessNamespaces
//                                                                              error:&er]];
//
//        tableView.alpha = [dict[@"show"] boolValue];
//
        NSError *err;
        NSString *strFileContent = [NSString stringWithContentsOfFile:[[NSBundle mainBundle]
                                                                       pathForResource: @"test" ofType: @"txt"] encoding:NSUTF8StringEncoding error:&err];
//        [ObjectInfo shareInstance].login = [dict[@"show"] boolValue] ? @"Yes" : @"No";
    
        [ObjectInfo shareInstance].login = @"Yes";

//        if(![dict[@"show"] boolValue])
        {
//            [ObjectInfo shareInstance].uInfo = [strFileContent objectFromJSONString][@"user_info"];
//
//            [ObjectInfo shareInstance].token = [strFileContent objectFromJSONString][@"access_token"];
//
//            [self.navigationController pushViewController:[AP_New_Main_ViewController new] animated:NO];
        }
//    }];
}

- (NSDictionary*)returnDictionary:(NSDictionary*)dict
{
    NSMutableDictionary * result = [NSMutableDictionary new];
    
    for(NSDictionary * key in dict[@"plist"][@"dict"][@"key"])
    {
        result[key[@"jacknode"]] = dict[@"plist"][@"dict"][@"string"][[dict[@"plist"][@"dict"][@"key"] indexOfObject:key]][@"jacknode"];
    }
    
    return result;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    kb = [[KeyBoard shareInstance] keyboardOn:@{} andCompletion:^(CGFloat kbHeight, BOOL isOn) {
        
        if ( ([[UIDevice currentDevice] orientation] ==  UIDeviceOrientationPortrait))
        {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, isOn ? 0 : 0, 0);
        }
        else
        {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, isOn ? kbHeight - 50 : 0, 0);
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [kb keyboardOff];
}

- (IBAction)didPressCheck:(UIButton*)sender
{
    [self addValue:[[self getValue:@"check"] isEqualToString:@"1"] ? @"0" : @"1" andKey:@"check"];

    [sender setImage:[UIImage imageNamed: [[self getValue:@"check"] isEqualToString:@"1"] ? @"on" : @"off"] forState:UIControlStateNormal];
}

- (IBAction)didPressLogIn:(id)sender
{
    [self.view endEditing:YES];
    
    if(![self isValid])
    {
        [self showToast:@"Bạn phải nhập đầy đủ thông tin đăng nhập" andPos:0];
        
        return;
    }
    
    [self didRequestLogin];
}

- (IBAction)didPressRegister:(id)sender
{
    [self.view endEditing:YES];

    AP_Register_ViewController * reg = [AP_Register_ViewController new];
    
    reg.delegate = self;
    
    [self.navigationController pushViewController:reg animated:YES];
}

- (void)didUpdateData:(NSDictionary*)dict
{
    uName.text = dict[@"uname"];
    
    pass.text = dict[@"pass"];
}

- (void)didRequestLayerList
{
    [[LTRequest sharedInstance] didRequestInfo:@{@"CMD_CODE":@"layer/list",
                                                 @"method":@"GET",
                                                 @"overrideAlert":@(1)
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated, NSDictionary* header) {
                                                     
                                                     if([errorCode isEqualToString:@"200"])
                                                     {
                                                         [ObjectInfo shareInstance].tiles = [responseString objectFromJSONString][@"array"];
                                                     }
                                                     
                                                 }];
}

- (void)didRequestLogin
{
    [[LTRequest sharedInstance] didRequestInfo:@{@"CMD_CODE":@"account/Token",
                                                 @"Username":uName.text,
                                                 @"Password":pass.text,
                                                 @"overrideLoading":@(1),
                                                 @"host":self,
                                                 @"overrideAlert":@(1),
                                                 @"postFix":@"account/Token"
                                                 } withCache:^(NSString *cacheString) {
                                                     
                                                 } andCompletion:^(NSString *responseString, NSString *errorCode, NSError *error, BOOL isValidated, NSDictionary* header) {
                                                     
                                                     switch ([errorCode intValue]) {
                                                         case 200:
                                                         {
                                                             [ObjectInfo shareInstance].uInfo = [responseString objectFromJSONString][@"user_info"];
                                                             
                                                             [ObjectInfo shareInstance].token = [responseString objectFromJSONString][@"access_token"];
                                                             
                                                             if([[self getValue:@"check"] isEqualToString:@"1"])
                                                             {
                                                                 [self addValue:uName.text andKey:@"name"];
                                                                 
                                                                 [self addValue:pass.text andKey:@"pass"];
                                                             }
                                                             else
                                                             {
                                                                 [self removeValue:@"name"];
                                                                 
                                                                 [self removeValue:@"pass"];
                                                             }
                                                             
//                                                             [self.navigationController pushViewController:[AP_New_Main_ViewController new] animated:YES];
                                                             [self.navigationController pushViewController:[AP_Map_ViewController new] animated:YES];
                                                         }
                                                         
                                                         break;
                                                         
                                                         case 401:
                                                         {
                                                             [self showToast:@"Đăng nhập thất bại, sai thông tin tài khoản" andPos:0];
                                                         }
                                                         
                                                         break;
                                                         
                                                         case 403:
                                                         {
                                                             [self showToast:@"Đăng nhập thất bại, tài khoản hiện tạm bị khóa" andPos:0];
                                                         }
                                                         
                                                         break;
                                                         
                                                         default:
                                                         {
                                                             [self showToast:@"Đăng nhập không thành công, mời bạn thử lại" andPos:0];
                                                         }
                                                         break;
                                                     }
                                                 }];
}

- (BOOL)isValid
{
    return [uName hasText] && [pass hasText];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didGoToMap
{
    [[Permission shareInstance] initLocation:NO andCompletion:^(LocationPermisionType type) {
        switch (type) {
            case lAlways:
            {
                //[self.navigationController pushViewController:[AP_Map_ViewController new] animated:YES];
            }
            break;
            case lDenied:
            {
                [self showToast:@"Bản đồ cần sử dụng vị trí của bạn" andPos:0];
            }
            break;
            case lDisabled:
            {
                [self showToast:@"Bản đồ cần sử dụng vị trí của bạn" andPos:0];
            }
            break;
            case lWhenUse:
            {
                //[self.navigationController pushViewController:[AP_Map_ViewController new] animated:YES];
            }
            break;
            case lRestricted:
            {
                [self showToast:@"Bản đồ cần sử dụng vị trí của bạn" andPos:0];
            }
            break;
            case lNotSure:
            {
                
            }
            break;
            
            default:
            break;
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return screenHeight1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
