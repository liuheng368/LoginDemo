//
//  UserInfoModel.swift
//  greatwall
//
//  Created by 刘恒 on 2019/5/24.
//  Copyright © 2019 dada. All rights reserved.
//
//  用户个人、职位信息

import UIKit

let REGISTER_TOKEN_LOCAL_FILENAME = "REGISTER_TOKEN_LOCAL_FILENAME"
class UserInfoModel: NSObject,NSCoding {
    
    /// 名称
    public var name:String = "name"
    
    /// 电话
    public var phone:String = ""
    
    /// 头像
    public var userPhoto:String = ""
    
    override init() {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.phone, forKey: "phone")
        aCoder.encode(self.userPhoto, forKey: "userPhoto")
    }
    
    required init(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as! String
        self.phone = aDecoder.decodeObject(forKey: "phone") as! String
        self.userPhoto = aDecoder.decodeObject(forKey: "userPhoto") as! String
    }
}

extension UserInfoModel {
    
    /// get
    ///
    public class func getInfoModel() -> UserInfoModel? {
        if let infoModel = LocalCacheManage.DDUnarchive(fileName: REGISTER_TOKEN_LOCAL_FILENAME) as? UserInfoModel {
            return infoModel
        }else{
            return nil
        }
    }
    
    /// update
    ///
    public class func updateUserInfoModel(_ userInfo:UserInfoModel){
        if LocalCacheManage.DDArchive(fileName: REGISTER_TOKEN_LOCAL_FILENAME, objc: userInfo) {
        }else{
            print("失败")
        }
    }
    
    /// clean
    ///
    public class func cleanUserInfoModel() {
        LocalCacheManage.DDFileDelete(fileName: REGISTER_TOKEN_LOCAL_FILENAME)
    }
}
