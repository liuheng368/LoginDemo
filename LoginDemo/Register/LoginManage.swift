//
//  LoginManage.swift
//  LoginDemo
//
//  Created by 刘恒 on 2019/6/10.
//  Copyright © 2019 刘恒. All rights reserved.
//

import UIKit

class LoginManage {

    typealias failCallBack = (_ errorCode:Int?) -> Void
    
    /// 密码登录
    ///
    /// - Parameters:
    ///   - userPhone: 用户名
    ///   - password: 密码
    ///   - fail: <#fail description#>
    public class func passWordLogin(userAccout:String, password:String, fail:@escaping failCallBack) {
        let resPassWord = RSAHandler.RSAEncryptedHandler(password) ?? ""
        /*
            与后端交互
         */
        LocalAuthManager.userLocalAuth("开启生物验证") {(state, error) -> (Void) in
            if state == .success {
                UserInfo.setUserInfoModel(userAccout, accessToken: resPassWord)
                loginSucess()
            }else{
                //生物识别虽然失败但登录依旧成功，所以不保存用户登录信息。
                loginSucess()
                fail(state.rawValue)
                print("认证失败")
            }
        }
    }
    
    
    /// 生物识别
    ///
    /// - Parameter fail: <#fail description#>
    public class func authLogin(fail:@escaping failCallBack) {
        LocalAuthManager.userLocalAuth("生物验证") {(state, error) -> (Void) in
            if state == .success {
                loginSucess()
            }else{
                fail(state.rawValue)
                print("登录失败")
            }
        }
    }
}

extension LoginManage{
    private class func loginSucess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcLogin = UIApplication.shared.keyWindow?.rootViewController
        let vcRoot = storyboard.instantiateViewController(withIdentifier: "RootViewController")
        UIApplication.shared.keyWindow?.rootViewController = vcRoot
        //手动释放登录页面
        vcLogin?.dismiss(animated: false, completion: nil)
    }
}
