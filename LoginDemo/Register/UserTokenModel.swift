//
//  UserLoginInfoModel.swift
//  greatwall
//
//  Created by 刘恒 on 2019/5/24.
//  Copyright © 2019 dada. All rights reserved.
//
//  用户登录信息

import UIKit

class UserTokenModel: NSObject {
    /// 登录获取
    
    /// 用户名（keychain保存）
    public var userAccout:String = ""    //Keychian - accout
    
    /// BD唯一身份码（keychain保存）
    public var accessToken:String = "user_token"    //Keychian -
    
    override init() {}
}

extension UserTokenModel {
    
    /// get
    ///
    public class func getLoginInfoModel() -> UserTokenModel? {
        do{
            if let model = try BDKeychianManage.fetchAllToken().first{
                let mm = UserTokenModel()
                mm.userAccout = model.key
                mm.accessToken = model.value
                return mm
            }else{return nil}
        }
        catch{return nil}
    }
    
    
    /// update
    ///
    public class func updateUserLoginInfoModel(_ userAccout:String, accessToken:String)->UserTokenModel?
    {
        //保证同时只有一个账号
        do {
            if let _ = try BDKeychianQuery.fetchKeychainData(account: userAccout){}
            else{
                try BDKeychianManage.deleteAllAccoutInfo()}
        } catch {}
        
        let model = UserTokenModel()
        model.accessToken = accessToken
        model.userAccout = userAccout
        do {
            try
                BDKeychianQuery.saveKeychainData(account: userAccout, accoutInfo: accessToken)
            return model
        } catch {
            print(accessToken)
            return nil
        }
    }
    
    
    /// clean
    ///
    public class func cleanUserLoginInfoModel() {
        do {
            try BDKeychianManage.deleteAllAccoutInfo()
        } catch {
            print(UserInfoShared.userLoginInfoModel.userAccout)
        }
    }
}
