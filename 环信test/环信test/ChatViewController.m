//
//  ChatViewController.m
//  环信test
//
//  Created by 张敏 on 16/4/5.
//  Copyright © 2016年 张敏. All rights reserved.
//

#import "ChatViewController.h"
#import "InputBoxView.h"

@interface ChatViewController ()<EMChatManagerDelegate,UITableViewDataSource,UITableViewDelegate>
//聊天消息tableview
@property(nonatomic,strong)UITableView *tableView;
//聊天的会话对象
@property(nonatomic,strong)EMConversation *conversation;
//聊天输入框
@property(nonatomic,strong)InputBoxView *inputBoxView;
@end

static NSString *ID = @"cellID";

@implementation ChatViewController

-(void)loadView{
    
    [super loadView];
    self.title = _name;
    
    //1.添加tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    
    [self.view addSubview:_tableView];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    
    //注册通知中心
    [self registerForKeyboardNotificatios];
    
    //cell不可点击
    [_tableView setAllowsSelection:NO];
    
    //2.添加输入框
    _inputBoxView = [[InputBoxView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-114, self.view.frame.size.width, 50)];
    __weak typeof(self) weakSelf = self;
    
    [self.view addSubview: _inputBoxView];
    
    //    点击发送时  block的实现
    _inputBoxView.buttonClickedBlock = ^(NSString *contentText){
        
        [weakSelf sendMessageWithContentText:contentText];
        
    };
    
    
    //设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    [self reloadChatData];
}


# pragma mark - Keyboard frame改变方法
//注册通知中心
- (void)registerForKeyboardNotificatios {
    
    //注册观察当键盘要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //注册观察当键盘要隐藏时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

//  移除通知中心
- (void)removeForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//   键盘将要弹出
- (void)didKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"--%f",keyboardSize.height);
    
    //输入框位置动画加载
    [self  beginMoveAnimation:keyboardSize.height];
    
}


//键盘将要隐藏
- (void)didKeyboardWillHide:(NSNotification *)notification {
    
    [self beginMoveAnimation:0];
}


//键盘改变后对应视图的变化
-(void)beginMoveAnimation: (CGFloat)height {
    [UIView animateWithDuration:0.5 animations:^{
        [_inputBoxView setFrame:CGRectMake(0, self.view.frame.size.height-(height+50), _inputBoxView.frame.size.width, _inputBoxView.frame.size.height)];
        
        
        CGRect frame = _tableView.frame;
        
        CGFloat  nowHeight = frame.size.height- height;
        frame.size.height = nowHeight;
        
        _tableView.frame = frame;
    }];
    
    [_tableView layoutIfNeeded];
    
    
    
    if ([_conversation loadAllMessages].count >1) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_conversation.loadAllMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
    
}

#pragma mark -- 刷新数据,重新加载tableview上面的聊天信息,并移动到最后一行
- (void)reloadChatData {
    
    //根据chatter获取一个会话对象conversation
    _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.name conversationType:eConversationTypeChat];
    
    [_tableView reloadData];
    
    if ([_conversation loadAllMessages].count > 0 ) {  //让信息滚动到底部
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_conversation.loadAllMessages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}



#pragma mark--发送消息

//用输入框文本  发送按钮发送消息
- (void)sendMessageWithContentText: (NSString *)contemtText{
    
    //1.文字消息构造
    EMChatText *txtChat = [[EMChatText alloc] initWithText:contemtText];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:txtChat];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithReceiver:self.name bodies:@[body]];
    message.messageType = eMessageTypeChat; // 设置为单聊消息
    [[EaseMob sharedInstance].chatManager asyncSendMessage:message progress:nil prepare:^(EMMessage *message, EMError *error) {
        //将要发送消息前的回调block
    } onQueue:nil completion:^(EMMessage *message, EMError *error) {
        //发送消息完成后的回调
        
        //刷新数据
        [self  reloadChatData];
        
    } onQueue:dispatch_get_main_queue()];
    
}

//接收在线消息
- (void)didReceiveMessage:(EMMessage *)message {
    //刷新数据
    [self reloadChatData];
}



//接收离线消息
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages {
    
    
    
}



#pragma mark -- 数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return 6;
    return _conversation.loadAllMessages.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        
    }
    
    //设置数据
    EMMessage *message = _conversation.loadAllMessages[indexPath.row];
    EMTextMessageBody *body = [message.messageBodies lastObject];
    //判断发送的人是否是当前聊天的人,左边是对面发过来的,右边是自己发过去的
    if ([message.to isEqualToString:self.name ] ){
        //自己  右边
        cell.detailTextLabel.text = body.text;
        cell.detailTextLabel.textColor = [UIColor blueColor];
        
    }else {  //好友  左边
        cell.textLabel.text = body.text;
        cell.textLabel.textColor = [UIColor redColor];
        
    }
    
    return cell ;
}

@end
