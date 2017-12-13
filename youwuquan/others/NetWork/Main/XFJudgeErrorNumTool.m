//
//  XFJudgeErrorNumTool.m
//  youwuquan
//
//  Created by mr.zhou on 2017/12/12.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFJudgeErrorNumTool.h"

@implementation XFJudgeErrorNumTool

+ (NSString *)judgeNumberWith:(NSString *)num {
    
    /*
     if("666".equals(sign)){
     appBean.setMsg("success");
     }
     if("100".equals(sign)){
     appBean.setMsg("user does not exist");
     }
     if("101".equals(sign)){
     appBean.setMsg("account already exist");
     }
     if("102".equals(sign)){
     appBean.setMsg("vcNum error");
     }
     if("103".equals(sign)){
     appBean.setMsg("vcNum be overdue");
     }
     if("104".equals(sign)){
     appBean.setMsg("password error");
     }
     if("105".equals(sign)){
     appBean.setMsg("duplicate login");
     }
     if("106".equals(sign)){
     appBean.setMsg("token is null");
     }
     if("107".equals(sign)){
     appBean.setMsg("token be overdue");
     }
     if("108".equals(sign)){
     appBean.setMsg("vcNum not obtained");
     }
     if("109".equals(sign)){
     appBean.setMsg("nike already exist");
     }
     if("110".equals(sign)){
     appBean.setMsg("incorrect phone format");
     }
     if("111".equals(sign)){
     appBean.setMsg("psw not complex enough");
     }
     if("112".equals(sign)){
     appBean.setMsg("vcNum not obtained");
     }
     if("113".equals(sign)){
     appBean.setMsg("token error");
     }
     if("201".equals(sign)){
     appBean.setMsg("image not obtained");
     }
     if("301".equals(sign)){
     appBean.setMsg("skillNo error");
     }
     if("302".equals(sign)){
     appBean.setMsg("the user has no skill");
     }
     if("303".equals(sign)){
     appBean.setMsg("this moment has been liked");
     }
     if("304".equals(sign)){
     appBean.setMsg("this moment has been unlocked");
     }
     if("305".equals(sign)){
     appBean.setMsg("can not unlock your own moment");
     }
     if("306".equals(sign)){
     appBean.setMsg("failed to get user information");
     }
     if("307".equals(sign)){
     appBean.setMsg("can not attention yourself");
     }
     if("308".equals(sign)){
     appBean.setMsg("today already sign in");
     }
     if("309".equals(sign)){
     appBean.setMsg("this user has been liked");
     }
     if("401".equals(sign)){
     appBean.setMsg("insufficient diamonds");
     }
     if("402".equals(sign)){
     appBean.setMsg("a referee cannot fill in himself");
     }
     */
    
    NSInteger number = [num integerValue];
    
    switch (number) {
            
        case 666:
        {
            return @"请求成功";
        }
            break;
            
        case 100:
        {
            return @"用户不存在";

        }
            break;
            
        case 101:
        {
            return @"用户已经存在";
        }
            break;
            
        case 102:
        {
            return @"验证码错误";
        }
            break;
            
        case 103:
        {
            return @"验证码失效";
        }
            break;
            
        case 104:
        {
            return @"密码错误";
        }
            break;
            
        case 105:
        {
            return @"重复登录";
        }
            break;
            
        case 106:
        {
            return @"token不存在";
        }
            break;
            
        case 107:
        {
            return @"token过期";
        }
            break;
            
        case 108:
        {
            return @"验证码错误";
        }
            break;
            
        case 109:
        {
            return @"用户名已经被注册";
        }
            break;
            
            
        case 110:
        {
            return @"手机号码格式错误";
        }
            break;
            
        case 111:
        {
            return @"密码格式错误";
        }
            break;
            
        case 113:
        {
            return @"token错误";
        }
            break;
            
        case 201:
        {
            return @"图片未获取";
        }
            break;
            
        case 301:
        {
            return @"网络错误";
        }
            break;
            
        case 302:
        {
            return @"用户没有技能";
        }
            break;
            
        case 303:
        {
            return @"已经赞过了哦";
        }
            break;
        case 305:
        {
            return @"不能解锁自己的动态";
        }
            break;
        case 306:
        {
            return @"获取用户信息失败";
        }
            break;
        case 307:
        {
            return @"不能关注自己";
        }
            break;
        case 308:
        {
            return @"今天已经签到过了";
        }
            break;
        case 309:
        {
            return @"已经关注过了";
        }
            break;
        case 401:
        {
            
            return @"钻石不足";
        }
            break;
        case 402:
        {
            
            return @"钻石不足";
        }
            break;
    }
    
    return @"";
}

@end
