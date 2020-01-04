//
//  Nav_ViewController.m
//  MapApp
//
//  Created by Thanh Hai Tran on 4/18/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "Nav_ViewController.h"

@interface Nav_ViewController ()

@end

@implementation Nav_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate
{
    return YES;//NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;//UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationMaskAll;//UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
