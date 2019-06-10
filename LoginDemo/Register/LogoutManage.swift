//
//  LogoutManage.swift
//  LoginDemo
//
//  Created by 刘恒 on 2019/6/10.
//  Copyright © 2019 刘恒. All rights reserved.
//

import UIKit

class LogoutManage {
    /// 登出
    public class func logout() {
        UserInfo.logouWithCleanLocation()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcRoot = UIApplication.shared.keyWindow?.rootViewController
        let vcLogin = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = vcLogin
        //手动释放登录页面
        vcRoot?.dismiss(animated: false, completion: nil)
    }
}
