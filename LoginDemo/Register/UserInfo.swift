//
//  UserInfo.swift
//  greatwall
//
//  Created by 刘恒 on 2019/5/23.
//  Copyright © 2019 dada. All rights reserved.
//

import UIKit

let UserInfoShared = UserInfo.shared

final class UserInfo: NSObject {
    
    public static let shared = UserInfo()
    
    /// 是否登录
    public class func isLogin() -> Bool{return shared._isLogin()}
    
    /// 登录用户个人信息
    private(set) var userLoginInfoModel : UserTokenModel = UserTokenModel()
    
    /// 登录用户职位信息
    private(set) var userInfoModel : UserInfoModel = UserInfoModel()
    
    private override init(){
        super.init()
        if let loginModel = UserTokenModel.getLoginInfoModel() {
            self.userLoginInfoModel = loginModel
        }
        if let infoModel = UserInfoModel.getInfoModel()  {
            self.userInfoModel = infoModel
        }
    }
}


// MARK: - 登录信息
extension UserInfo {

    /// 更新本地登录信息
    ///
    public class func setUserInfoModel(_ userAccout:String, accessToken:String)
    {
        if let model = UserTokenModel.updateUserLoginInfoModel(userAccout, accessToken: accessToken)
        {
            shared.userLoginInfoModel = model
        }
    }

    private func _isLogin() -> Bool {
        if userLoginInfoModel.accessToken.count > 0 &&
            userLoginInfoModel.userAccout.count > 0 {
            return true
        }
        return false
    }
}


//MARK: - 个人信息
extension UserInfo {

    /// 更新本地个人信息
    ///
    public class func setUserVirtualModel(_ userInfo:UserInfoModel)
    {
        shared.userInfoModel = userInfo
        UserInfoModel.updateUserInfoModel(userInfo)
    }
}


// MARK: - 退出登录
extension UserInfo {

    ///  清空本地用户数据
    ///
    public class func logouWithCleanLocation(){
        UserTokenModel.cleanUserLoginInfoModel()
        UserInfoModel.cleanUserInfoModel()
    }
}



