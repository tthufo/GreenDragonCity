//
//  AppDelegate.m
//  MapApp
//
//  Created by Thanh Hai Tran on 4/9/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

#import "AppDelegate.h"

#import "AP_Login_ViewController.h"

#import "Nav_ViewController.h"

#import "AP_New_Main_ViewController.h"

#import "DashBoard_ViewController.h"

@import GoogleMaps;


@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize isTurn;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[LTRequest sharedInstance] initRequest];
        
    [GMSServices provideAPIKey:APIMAP];
    
    if([self isIphoneX])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    NSMutableDictionary * dict = [[self getObject:@"setting"] reFormat];
    
    dict[@"show"] = @"0";
    
    [self addObject:dict andKey:@"setting"];
    
    AP_Login_ViewController * login = [AP_Login_ViewController new];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:login];
    
    nav.navigationBarHidden = YES;
    
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([[self topViewController] isKindOfClass:[DashBoard_ViewController class]]) {
        [(DashBoard_ViewController*)[self topViewController] replayVideo];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return isTurn ? UIInterfaceOrientationMaskLandscape : UIInterfaceOrientationMaskPortrait;
//}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
//    id presentedViewController = [self topViewController];
//    NSString *className = presentedViewController ? NSStringFromClass([presentedViewController class]) : nil;
    
//    if([[self topViewController] isKindOfClass:[AP_New_Main_ViewController class]])
//    {
//        return UIInterfaceOrientationMaskPortrait;
//    }
    
//    if(((UIView*)[[[UIApplication sharedApplication]windows]objectAtIndex:0].subviews.lastObject).tag == 999999)
//    {
//        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
//
//        if(interfaceOrientation == 4 || interfaceOrientation == 3)
//        {
//            return UIInterfaceOrientationMaskLandscape;
//        }
//        else {
            return UIInterfaceOrientationMaskPortrait;
//
//        }
//    }
//
//    return UIInterfaceOrientationMaskAll;
}

- (UIViewController *)topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController)
    {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

- (UIViewController *) topViewController {
    UIViewController *baseVC = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([baseVC isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)baseVC).visibleViewController;
    }
    
    if ([baseVC isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedTVC = ((UITabBarController*)baseVC).selectedViewController;
        if (selectedTVC) {
            return selectedTVC;
        }
    }
    
    if (baseVC.presentedViewController) {
        return baseVC.presentedViewController;
    }
    return baseVC;
}

@end

@implementation UIView (ahihi)

- (void)selfVisible
{
    self.alpha = 0;
    
    [UIView transitionWithView:self
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.alpha = 1;
                    } completion:NULL];
}

- (void)imageUrl:(NSString*)url
{
    [(UIImageView*)self sd_setImageWithURL:[NSURL URLWithString:[[url isEqual:[NSNull null]] ? @"" : url encodeUrl]] placeholderImage:kAvatar completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

        if (error) return;
        if (image && cacheType == SDImageCacheTypeNone)
        {
            [UIView transitionWithView:(UIImageView*)self
                              duration:0.2
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                [(UIImageView*)self setImage:image];
                            } completion:NULL];
        }
    }];
}

- (void)imageUrlNoCache:(NSString*)url andCache:(UIImage*)image
{
    [(UIImageView*)self sd_setImageWithURL:[NSURL URLWithString:[[url isEqual:[NSNull null]] ? @"" : url encodeUrl]] placeholderImage:image ? image : kAvatar];
}

@end

@implementation NSMutableAttributedString (color)

- (void)setColorForText:(NSString*) textToFind withColor:(UIColor*) color
{
    NSRange range = [self.mutableString rangeOfString:textToFind options:NSCaseInsensitiveSearch];
    
    if (range.location != NSNotFound) {
        [self addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
}

@end

@implementation NSObject (XXX)

- (BOOL)isIphoneX
{
    if (@available(iOS 11.0, *))
    {
        UIWindow *window = UIApplication.sharedApplication.keyWindow;
        CGFloat topPadding = window.safeAreaInsets.top;
        if(topPadding > 24)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (BOOL)hasBottomNotch
{
    if (@available(iOS 11.0, *))
    {
        return [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom > 20.0;
    }

    return  NO;
}

@end
