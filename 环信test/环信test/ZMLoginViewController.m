//
//  ZMLoginViewController.m
//  环信test
//
//  Created by 张敏 on 16/4/2.
//  Copyright © 2016年 张敏. All rights reserved.
//

#import "ZMLoginViewController.h"
#import "ZMChatTabBarController.h"
#import "MBProgressHUD+Ex.h"
@interface ZMLoginViewController ()

@property(nonatomic,weak)UITextField *nameField;
@property(nonatomic,weak)UITextField *passwordField;

@property(nonatomic,weak)UIButton *loginButton;
@property(nonatomic,weak)UIButton *registerButton;





@end

@implementation ZMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self setupUI];
    //测试账号
    _nameField.text = @"111111cc";
    _passwordField.text = @"111";
}


//创建视图
-(void)setupUI{
    //账号
    UITextField *nameField = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 250, 44)];
    nameField.placeholder = @"个人账号/手机";
    nameField.clearsOnBeginEditing = YES;
    nameField.clearButtonMode =UITextFieldViewModeWhileEditing;
    
    
    [self.view addSubview:nameField];
    self.nameField =nameField;
    
    //密码
    UITextField *passwordField = [[UITextField alloc]initWithFrame:CGRectMake(50, 160, 250, 44)];
    passwordField.placeholder = @"密码";
    passwordField.clearsOnBeginEditing = YES;
    passwordField.clearButtonMode =UITextFieldViewModeWhileEditing;

    [self.view addSubview:passwordField];
    self.passwordField = passwordField;
    
    //注册
    UIButton * registerButton = [[UIButton alloc]initWithFrame:CGRectMake(50, 220, 100, 44)];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    registerButton.backgroundColor = [UIColor yellowColor];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    //添加监听事件
    [registerButton addTarget:self action:@selector(clickregisterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    self.registerButton = registerButton;
    
    
    //登录
    UIButton * loginButton = [[UIButton alloc]initWithFrame:CGRectMake(150, 220, 150, 44)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor greenColor];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //添加监听事件
    [loginButton addTarget:self action:@selector(clickloginButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    self.loginButton = loginButton ;
    
    
    
    
}

//注册账号事件
-(void)clickregisterButton:(UIButton *)sender{
    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:_nameField.text password:_passwordField.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
        if (!error) {
            NSLog(@"注册成功");
        }else{
             NSLog(@"%@",error);
        }
    } onQueue:dispatch_get_main_queue()];

}




//登录账号事件
-(void)clickloginButton:(UIButton *)sender{
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:_nameField.text password:_passwordField.text completion:^(NSDictionary *loginInfo, EMError *error) {
        if (!error && loginInfo) {
            NSLog(@"登陆成功");
//            [MBProgressHUD showMessage:@"正在登录中"];
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
                //隐藏提示框
//                 [MBProgressHUD hideHUD];
            ZMChatTabBarController *chatTabBarV = [[ZMChatTabBarController alloc]init];
            //切换window的跟控制器
            UIWindow *win = [UIApplication sharedApplication].keyWindow;
            
            win.rootViewController = chatTabBarV;
//            });
            
        }else{
            // 显示错误信息的警告
            [MBProgressHUD showError:@"用户名或密码错误"];
            NSLog(@"%@",error);
        }
        
    } onQueue:dispatch_get_main_queue()];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //点击屏幕时让键盘回收
    [_passwordField resignFirstResponder];
    [_nameField resignFirstResponder];
}
@end
