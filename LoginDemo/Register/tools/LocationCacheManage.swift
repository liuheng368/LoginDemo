//
//  LocationCacheManage.swift
//  LoginDemo
//
//  Created by 刘恒 on 2019/6/5.
//  Copyright © 2019 刘恒. All rights reserved.
//
//  本地缓存（归档）
//  注：所有文件的根目录都是.../document/

import Foundation

enum enum_createDirectory_result:Int {
    case fileSuccess = 0
    case fileExists
    case fileFail
}

let mainPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/"
let fileManage_ = FileManager.default
final class LocalCacheManage: NSObject {
    
    /// 文件、文件夹删除
    @discardableResult
    public static func DDFileDelete(_ documentName:String="", fileName:String="") -> Bool {
        guard documentName.count > 0 || fileName.count > 0 else{return false}
        let path = mainPath + documentName + "/" + fileName
        do{
            try fileManage_.removeItem(atPath: path)
            return true
        }catch{
            return false
        }
    }
    
    /// 归档
    @discardableResult
    public static func DDArchive(_ documentName:String="", fileName:String,objc:AnyObject) -> Bool{
        let path = mainPath + (documentName.count > 0 ? "\(documentName)/" : "") + fileName
        if #available(iOS 11.0, *) {
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: objc, requiringSecureCoding: false)
                do {
                    try data.write(to: URL(fileURLWithPath: path))
                } catch {
                    assert(true, "无法写入path")
                    return false
                }
            } catch {
                assert(true, "无法生成归档数据")
                return false
            }
        }else{
            return NSKeyedArchiver.archiveRootObject(objc, toFile: path)
        }
        return true
    }
    
    /// 解档
    public static func DDUnarchive(_ documentName:String="", fileName:String) -> AnyObject? {
        let path = mainPath + (documentName.count > 0 ? "\(documentName)/" : "") + fileName
        if #available(iOS 11.0, *) {
            do{
                let data = try Data.init(contentsOf: URL(fileURLWithPath: path))
                do{
                    return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data)  as AnyObject
                } catch {
                    assert(true, "用户数据解档失败")
                }
            } catch {
                assert(true, "用户数据解档路径错误")
            }
        }else{
            return NSKeyedUnarchiver.unarchiveObject(withFile: path) as AnyObject?
        }
        return nil
    }
}
