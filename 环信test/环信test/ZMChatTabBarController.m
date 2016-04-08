//
//  ZMChatTabBarController.m
//  环信test
//
//  Created by 张敏 on 16/4/3.
//  Copyright © 2016年 张敏. All rights reserved.
//

#import "ZMChatTabBarController.h"
#import "ZMFriendListTableVC.h"
#import "ZMSettingTableVC.h"
#import "ZMContactsTableVC.h"

@interface ZMChatTabBarController ()

@end

@implementation ZMChatTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addChildViewController];
     
    
    
}

// 添加所有子控制器
-(void)addChildViewController{
    
    // 设置 tabBar 的 tintColor
    //    self.tabBar.tintColor = [UIColor redColor];
    
    //添加子控制器
     [self  addChildViewController:[[ZMFriendListTableVC alloc]init] title:@"通讯录" imageName:@"tabbar_home"];
    [self addChildViewController:[[ZMContactsTableVC alloc] init] title:@"会话" imageName:@"tabbar_message_center"];
    [self addChildViewController:[[ZMSettingTableVC alloc] init] title:@"设置" imageName:@"tabbar_profile"];
   

    
    
}


//添加子控制器

-(void)addChildViewController:(UIViewController *)childController  title:(NSString *)title   imageName:(NSString *)imgName{
    
    childController.title = title;
    
    childController.tabBarItem.image = [UIImage imageNamed:imgName];
    NSString *selectedImgName = [NSString stringWithFormat:@"%@_selected",imgName];
    //选中图片
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImgName];
    
    //设置navigationC的跟控制器
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:childController];
    
    [self addChildViewController:navC];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
