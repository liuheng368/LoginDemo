//
//  AuthID.swift
//  LoginDemo
//
//  Created by 刘恒 on 2019/6/5.
//  Copyright © 2019 刘恒. All rights reserved.
//
//  生物验证

import Foundation
import LocalAuthentication

enum LocalAuthStatus : Int {
    case success             //成功
    case failed              //失败
    case passwordNotSet      //未设置手机密码
    case touchidNotSet       //未设置指纹
    case touchidNotAvailable //不支持指纹
    case cancleSys           //系统取消
    case canclePer           //用户取消
    case inputNUm            //输入密码
}

enum BiometryType : Int {
    case none
    case touchID
    case faceID
}

typealias localAuthBlock = (LocalAuthStatus,Error?)->(Void)

class LocalAuthManager {
    
    public static func getBiometryType() -> BiometryType{
        //该参数必须在canEvaluatePolicy方法后才有值
        let authContent = LAContext()
        var error: NSError?
        if authContent.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            //iPhoneX出厂最低系统版本号：iOS11.0.0
            if #available(iOS 11.0, *) {
                if authContent.biometryType == .faceID {
                    return .faceID
                }else if authContent.biometryType == .touchID {
                    return .touchID
                }
            } else {
                guard let laError = error as? LAError else{
                    return .none
                }
                if laError.code != .touchIDNotAvailable {
                    return .touchID
                }
            }
        }
         return .none
    }
    
    public static func userLocalAuth(_ strTips:String="", block:@escaping localAuthBlock){
        let authContent = LAContext()
        //如果为空不展示输入密码的按钮
        authContent.localizedFallbackTitle = strTips
        var error: NSError?
        /*
         LAPolicy有2个参数：
         用TouchID/FaceID验证，如果连续出错则需要锁屏验证手机密码，
         但是很多app都是用这个参数，等需要输入密码解锁touchId&faceId再弃用该参数。
         优点：用户在单次使用后就可以取消验证。
         1，deviceOwnerAuthenticationWithBiometrics
         
         用TouchID/FaceID或密码验证, 默认是错误两次或锁定后, 弹出输入密码界面
         等错误次数过多验证被锁时启用该参数
         2，deviceOwnerAuthentication
         
         */
        if authContent.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            authContent.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: strTips) {(success,error) in
                if success {
                    //evaluatedPolicyDomainState 只有生物验证成功才会有值
                    if let _ = authContent.evaluatedPolicyDomainState {
                        //如果不放在主线程回调可能会有5-6s的延迟
                        DispatchQueue.main.async {
                            print("验证成功")
                            block(.success, error)
                        }
                    }else{
                        DispatchQueue.main.async {
                            print("设备密码输入正确")
                        }
                    }
                }else{
                    guard let laError = error as? LAError else{
                        DispatchQueue.main.async {
                            print("touchID不可用")
                            block(.touchidNotAvailable,error)
                        }
                        return
                    }
                    switch laError.code {
                    case .authenticationFailed:
                        DispatchQueue.main.async {
                            print("连续三次输入错误，身份验证失败")
                            block(.failed, error)
                        }
                    case .userCancel:
                        DispatchQueue.main.async {
                            print("用户点击取消按钮。")
                            block(.canclePer, error)
                        }
                    case .userFallback:
                        DispatchQueue.main.async {
                            print("用户点击输入密码")
                            block(.inputNUm, error)
                        }
                    case .systemCancel:
                        DispatchQueue.main.async {
                            print("系统取消")
                            block(.cancleSys,error)
                        }
                    case .passcodeNotSet:
                        DispatchQueue.main.async {
                            print("用户未设置密码")
                            block(.passwordNotSet,error)
                        }
                    case .touchIDNotAvailable:
                        DispatchQueue.main.async {
                            print("touchID不可用")
                            block(.touchidNotAvailable,error)
                        }
                    case .touchIDNotEnrolled:
                        DispatchQueue.main.async {
                            print("touchID未设置指纹")
                            block(.touchidNotSet,error)
                        }
                    case .touchIDLockout:
                        DispatchQueue.main.async {
                            print("touchID输入次数过多验证被锁")
                            unlockLocalAuth()
                        }
                    default:break
                    }
                }
            }
        }else{
            print("设备不支持或验证多次后被锁定")
            unlockLocalAuth()
        }
    }
}

extension LocalAuthManager {
    
    private static func unlockLocalAuth() {
        let passwordContent = LAContext()
        var error: NSError?
        if passwordContent.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error){
            passwordContent.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "需要您的密码，才能启用 Touch ID") { (success, err) in
                if success {
                    print("密码解锁成功")
                }else{
                    print(err!)
                    print(error!)
                }
            }
        }else{
            
        }
    }
}
