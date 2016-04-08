//
//  InputBoxView.h
//  环信test
//
//  Created by 张敏 on 16/4/5.
//  Copyright © 2016年 张敏. All rights reserved.
//发送信息的输入框

#import <UIKit/UIKit.h>

//定义block
typedef void(^ButtonClickedBlock)(NSString *contentText);

@interface InputBoxView : UIView
@property(nonatomic,copy)ButtonClickedBlock buttonClickedBlock;
@end
