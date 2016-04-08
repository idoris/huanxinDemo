//
//  InputBoxView.m
//  环信test
//
//  Created by 张敏 on 16/4/5.
//  Copyright © 2016年 张敏. All rights reserved.
//

#import "InputBoxView.h"


@interface InputBoxView ()

@property(nonatomic,weak)UITextField *contentField;
@property(nonatomic,weak)UIButton *sendButton;
@end

@implementation InputBoxView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self setupUI];
        
    }
    return self;
    
}

//设置视图
-(void)setupUI{
    
    UITextField *contentField = [[UITextField alloc]initWithFrame:CGRectMake(5, 5,self.frame.size.width - 100, self.frame.size.height - 10) ];
    contentField.placeholder = @"说点什么呢";
    contentField.font = [UIFont systemFontOfSize:15];
    contentField.borderStyle = UITextBorderStyleRoundedRect;
    [self addSubview:contentField];
    self.contentField = contentField;
    
    UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 90, 5,85, self.frame.size.height - 10)];
    sendButton.backgroundColor  = [UIColor colorWithRed:1 green:0 blue:128 / 255.0 alpha:1];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    sendButton.layer.masksToBounds = YES;
    sendButton.layer.cornerRadius = 5;
    
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:sendButton];
    self.sendButton = sendButton;
    
}

//发送信息
- (void)sendButtonClick {
    if (self.buttonClickedBlock) {
        //点击发送时  调用block
        self.buttonClickedBlock(self.contentField.text);
        
    }
    self.contentField.text = @"";
    
}



@end
