//
//  AP_Web_List_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 5/23/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "AP_Web_List_ViewController.h"

#import <WebKit/WebKit.h>

@interface AP_Web_List_ViewController ()
{
    IBOutlet NSLayoutConstraint * topBar;

    IBOutlet UIWebView * webView;
    
    IBOutlet UILabel * titleLabel;
}
@end

@implementation AP_Web_List_ViewController

@synthesize url, content, label;

- (void)viewDidLoad
{
    [super viewDidLoad];

    titleLabel.text = label;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11"))
    {
        topBar.constant = 44;
    }
    
    if(content)
    {
        [webView loadHTMLString:content baseURL:nil];
    }
    else
    {
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}

- (IBAction)didPressBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
