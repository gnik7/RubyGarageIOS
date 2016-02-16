//
//  NGProgress.m
//  RubyGarageIOS
//
//  Created by comp23 on 2/13/16.
//  Copyright © 2016 Nikita Gil'. All rights reserved.
//

#import "NGProgress.h"

@interface NGProgress()

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation NGProgress




- (void) createProgressHUD {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = window.rootViewController;
    
    self.hud = [MBProgressHUD showHUDAddedTo: rootViewController.view animated:YES];
    self.hud.labelText = @"Loading";
}

- (void) createProgressHUDOn {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *rootViewController = window.rootViewController.presentedViewController.view;
    
    self.hud = [MBProgressHUD showHUDAddedTo: rootViewController animated:YES];
    self.hud.labelText = @"Loading";
}


- (void) hideProgressHUD {
    [self.hud hide:true];
    self.hud = nil;
}

@end


