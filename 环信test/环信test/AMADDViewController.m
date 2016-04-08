//
//  AMADDViewController.m
//  环信test
//
//  Created by 张敏 on 16/4/4.
//  Copyright © 2016年 张敏. All rights reserved.
//

#import "AMADDViewController.h"
#import "MBProgressHUD+Ex.h"
@interface AMADDViewController ()
@property(nonatomic,strong)UITextField *nameField; //用户名
@end

@implementation AMADDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加好友";
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 100, 60, 50)];
    label.text = @"用户名";
    [self.view addSubview:label];
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 200, 50)];
    _nameField.placeholder = @"请输入用户名";
    
    
    [self.view addSubview:_nameField];
    
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 200, 100, 50)];
    [addButton setTitle:@"添加" forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];

    
    //点击事件
    [addButton addTarget:self action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:addButton];
    
    
    
    
}


//添加好友
-(void)addFriend{
    
    //添加好友
    [MBProgressHUD showMessage:@"添加成功,等待对方确认"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //隐藏提示框
        [MBProgressHUD hideHUD];
        
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:_nameField.text  message:@"我想加您为好友" error:&error];
        if (isSuccess && !error) {
            NSLog(@"添加成功");
            
        }
        //跳转到好友列表界面
            [self.navigationController popViewControllerAnimated:YES];
        
    });
    
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
