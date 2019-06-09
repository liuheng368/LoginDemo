//
//  UserInfoModel.swift
//  greatwall
//
//  Created by 刘恒 on 2019/5/24.
//  Copyright © 2019 dada. All rights reserved.
//
//  用户个人、职位信息

import UIKit

let BD_REGISTER_TOKEN_LOCAL_FILENAME = "BD_REGISTER_TOKEN_LOCAL_FILENAME"
class UserInfoModel: NSObject,NSCoding {
    
    /// BD名称
    private(set) var name:String = "name"
    
    /// BD电话
    private(set) var phone:String = ""
    
    /// 头像
    private(set) var userPhoto:String = ""
    
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
        if let infoModel = LocalCacheManage.DDUnarchive(fileName: BD_REGISTER_TOKEN_LOCAL_FILENAME) as? UserInfoModel {
            return infoModel
        }else{
            return nil
        }
    }
    
    /// update
    ///
    public class func updateUserInfoModel(_ userInfo:UserInfoModel){
        if LocalCacheManage.DDArchive(fileName: BD_REGISTER_TOKEN_LOCAL_FILENAME, objc: userInfo) {
        }else{
            print("失败")
        }
    }
    
    /// clean
    ///
    public class func cleanUserInfoModel() {
        LocalCacheManage.DDFileDelete(fileName: BD_REGISTER_TOKEN_LOCAL_FILENAME)
    }
}
