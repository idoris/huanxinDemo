//
//  AppDelegate.m
//  环信test
//
//  Created by 张敏 on 16/4/1.
//  Copyright © 2016年 张敏. All rights reserved.
//

#import "AppDelegate.h"
#import "EaseMob.h"
#import "ZMLoginViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //registerSDKWithAppKey:注册的appKey，详细见下面注释。
    //apnsCertName:推送证书名(不需要加后缀)，详细见下面注释。
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"minmin2016#zhang123" apnsCertName:nil];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //1.创建窗口并确定大小
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    ZMLoginViewController *loginVC = [[ZMLoginViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    loginVC.navigationItem.title = @"登录中心";
    
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
    
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
// App进入后台

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
    
}

@end
