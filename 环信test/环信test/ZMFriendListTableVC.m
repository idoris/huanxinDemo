//
//  ZMFriendListTableVC.m
//  环信test
//
//  Created by 张敏 on 16/4/3.
//  Copyright © 2016年 张敏. All rights reserved.
//

#import "ZMFriendListTableVC.h"
#import "ZMLoginViewController.h"
#import "AMADDViewController.h"
#import "ChatViewController.h"

@interface ZMFriendListTableVC ()<EMChatManagerDelegate,EMChatManagerBuddyDelegate,IChatManagerDelegate>
@property(nonatomic,strong)NSMutableArray *listArray;

@end
static NSString *ID = @"cell";//重用标识符

@implementation ZMFriendListTableVC


-(void)loadView{
    
    [super loadView];
    
    //左侧注销按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(didClickedCancelButton)];

    //自动获取通讯录列表
    [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
        
        if (!error) {
            NSLog(@"获取成功 -- %@", buddyList);
            
            [_listArray removeAllObjects];
            [_listArray addObjectsFromArray:buddyList];
            [self.tableView reloadData];
        }
    } onQueue:dispatch_get_main_queue()];
    

}


- (void)viewDidLoad {
    [super viewDidLoad];
        //初始化数组
    _listArray = [NSMutableArray array];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClick)];
    
    //设置代理
    [ [EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
}

//

//左上角的注销按钮
-(void)didClickedCancelButton{
    
    //注销用户
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    
    //跳转到登录界面的控制器
    ZMLoginViewController *loginVC = [[ZMLoginViewController alloc]init];
    
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    win.rootViewController = loginVC;
    
}

//右上角添加好友事件
-(void)addButtonClick{
    
    //跳转到添加好友控制器
    [self.navigationController pushViewController:[[AMADDViewController alloc]init] animated:YES];
    
    
}


//代理方法
//监听加好友请求
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message{
    
    //创建弹出框控制器
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"来自好友%@的请求",username] message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    //1.同意行为
    UIAlertAction *accipetAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 同意好友请求的方法
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager acceptBuddyRequest:username error:&error];
        if (isSuccess && !error) {
            NSLog(@"发送同意成功");
            //同意后刷新数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //刷新数据
                [[EaseMob sharedInstance].chatManager asyncFetchBuddyListWithCompletion:^(NSArray *buddyList, EMError *error) {
                    
                    if (!error) {
                        NSLog(@"获取成功 --张敏 %@", buddyList);
                        
                                                [_listArray removeAllObjects];
                                                [_listArray addObjectsFromArray:buddyList];
                                                [self.tableView reloadData];
                    }
                } onQueue:dispatch_get_main_queue()];
                
            });
            
            
        }
    }];
    
    //2.拒绝行为
    UIAlertAction *rejectAction = [UIAlertAction actionWithTitle:@"拒绝" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 拒绝好友请求的方法
        EMError *error = nil;
        BOOL isSuccess = [[EaseMob sharedInstance].chatManager rejectBuddyRequest:username reason:@"不想鸟你" error:&error];
        if (isSuccess && !error) {
            NSLog(@"发送拒绝成功");
        }
    }];
    
    [alertController addAction:accipetAction];
    [alertController addAction:rejectAction];
    
        [self showDetailViewController:alertController sender:nil];
    
}


////好友请求被接受时的回调
//- (void)didAcceptedByBuddy:(NSString *)username{
//    
//
//    
//    
//}
////好友请求被拒绝时的回调
//- (void)didRejectedByBuddy:(NSString *)username{
//    
//}


#pragma mark-- tableView 的代理方法
//选中某行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatViewController *chatVC = [[ChatViewController alloc]init];
    EMBuddy *buddy = _listArray[indexPath.row];
    chatVC.name =  buddy.username;
    
    //跳转到聊天界面
    [self.navigationController pushViewController:chatVC animated:YES];
    
}




#pragma mark - Table view data source


//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
//多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}

//每行内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    

    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }
    //赋值
    EMBuddy *buddy = _listArray[indexPath.row];
    cell.textLabel.text = buddy.username;
    NSLog(@"--zhang---%@",buddy);
    
    return cell;
}





@end
